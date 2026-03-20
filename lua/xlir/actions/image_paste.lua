local lir = require('lir')

local image_paste = function()
  local path = lir.get_context().dir .. '/image.png'

  -- 相対パスを絶対パスに
  local abs_path = vim.fn.fnamemodify(path, ":p")

  -- WSLパス -> Windowsパス
  local win_path = vim.fn.system({ "wslpath", "-w", abs_path }):gsub("%s+$", "")

  local ps_script = table.concat({
    "Add-Type -AssemblyName System.Windows.Forms;",
    "Add-Type -AssemblyName System.Drawing;",
    "$img = [System.Windows.Forms.Clipboard]::GetImage();",
    "if ($null -eq $img) {",
    "  Write-Error 'Clipboard does not contain an image.';",
    "  exit 1",
    "}",
    "$img.Save('" .. win_path:gsub("'", "''") .. "', [System.Drawing.Imaging.ImageFormat]::Png);",
  }, " ")

  local result = vim.system({
    "powershell.exe",
    "-NoProfile",
    "-NonInteractive",
    "-STA",
    "-Command",
    ps_script,
  }, { text = true }):wait()

  if result.code ~= 0 then
    vim.notify(
      "画像保存に失敗: " .. ((result.stderr and result.stderr ~= "") and result.stderr or "unknown error"),
      vim.log.levels.ERROR
    )
    return false
  end

  -- 更新し、カーソル位置を変更
  vim.cmd('edit')

  local lnum = lir.get_context():indexof("image.png")
	if lnum then
		vim.cmd(tostring(lnum))
	end

  vim.notify("保存しました: " .. abs_path, vim.log.levels.INFO)
  return true
end

return image_paste


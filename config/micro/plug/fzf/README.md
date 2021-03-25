# Provides a `fzf` command in micro to open a file in the current pane using fzf.

命令查找

https://github.com/zyedidia/micro/blob/6f949fe9853899caffb2629c98b280463e54687b/internal/action/command.go#L32

在lua文件中bp对象可以调用

```go
func InitCommands() {
	commands = map[string]Command{
		"set":        {(*BufPane).SetCmd, OptionValueComplete},
		"reset":      {(*BufPane).ResetCmd, OptionValueComplete},
		"setlocal":   {(*BufPane).SetLocalCmd, OptionValueComplete},
		"show":       {(*BufPane).ShowCmd, OptionComplete},
		"showkey":    {(*BufPane).ShowKeyCmd, nil},
		"run":        {(*BufPane).RunCmd, nil},
		"bind":       {(*BufPane).BindCmd, nil},
		"unbind":     {(*BufPane).UnbindCmd, nil},
		"quit":       {(*BufPane).QuitCmd, nil},
		"goto":       {(*BufPane).GotoCmd, nil},
		"save":       {(*BufPane).SaveCmd, nil},
		"replace":    {(*BufPane).ReplaceCmd, nil},
		"replaceall": {(*BufPane).ReplaceAllCmd, nil},
		"vsplit":     {(*BufPane).VSplitCmd, buffer.FileComplete},
		"hsplit":     {(*BufPane).HSplitCmd, buffer.FileComplete},
		"tab":        {(*BufPane).NewTabCmd, buffer.FileComplete},
		"help":       {(*BufPane).HelpCmd, HelpComplete},
		"eval":       {(*BufPane).EvalCmd, nil},
		"log":        {(*BufPane).ToggleLogCmd, nil},
		"plugin":     {(*BufPane).PluginCmd, PluginComplete},
		"reload":     {(*BufPane).ReloadCmd, nil},
		"reopen":     {(*BufPane).ReopenCmd, nil},
		"cd":         {(*BufPane).CdCmd, buffer.FileComplete},
		"pwd":        {(*BufPane).PwdCmd, nil},
		"open":       {(*BufPane).OpenCmd, buffer.FileComplete},
		"tabmove":    {(*BufPane).TabMoveCmd, nil},
		"tabswitch":  {(*BufPane).TabSwitchCmd, nil},
		"term":       {(*BufPane).TermCmd, nil},
		"memusage":   {(*BufPane).MemUsageCmd, nil},
		"retab":      {(*BufPane).RetabCmd, nil},
		"raw":        {(*BufPane).RawCmd, nil},
		"textfilter": {(*BufPane).TextFilterCmd, nil},
	}
}
```

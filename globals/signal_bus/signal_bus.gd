extends Node

# --- Signaler til oppgavene ---
signal task_completed(task_type: String)
signal send_web_data(task: WebData)
signal send_boss_web(task: WebData)
signal send_boss_download(task: )
signal test
signal sent_message(message: String, shift: int)
signal encrypted(message: String)

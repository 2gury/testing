/*Функция инициализации очереди процессов*/
int init_process_queue(void);
/*Функция для освобождения очереди процессов*/
int release_process_queue(void);
/*Функция для добавления процесса в очередь процессов*/
int add_process_to_queue(int pid);
/*Функция для удаления процесса из очереди процессов*/
int remove_process_from_queue(int pid);
/*Функция для вывода очереди процессов*/
int print_process_queue(void);
/*Функция для смены состояния процесса в очереди процессов*/
int change_process_state_in_queue(int pid, int changeState);
/*Функция для получения первого процесса в очереди процессов*/
int get_first_process_in_queue(void);
/*Функция для удаления всех завершенных процессов из очереди процессов*/
int remove_terminated_processes_from_queue(void);

static DECLARE_DELAYED_WORK(scheduler_hdlr, context_switch);

static void context_switch(struct work_struct *w);

static int __init module_init(void)
{
    ...
    /*Выделение workqueue под именем "scheduler-wq" и количество планировщиков = 1*/
    scheduler_wq = alloc_workqueue("scheduler-wq", WQ_UNBOUND, 1);
    ...
    /*Установка задержки для выполнения работ заданного тарифа*/
    q_status = queue_delayed_work(scheduler_wq, &scheduler_hdlr, time_quantum * HZ);
    ...
}

static void __exit module_cleanup(void)
{
    ...
    cancel_delayed_work(&scheduler_hdlr);
    /*Удаление всех отложенных заданий рабочей очереди*/
    flush_workqueue(scheduler_wq);
    /*Освобождение рабочей очереди*/
    destroy_workqueue(scheduler_wq);
    ...
}

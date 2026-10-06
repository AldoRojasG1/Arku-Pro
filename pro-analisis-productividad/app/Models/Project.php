<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Project extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'description',
        'status',
        'start_date',
        'deadline',
        'color',
        'goals',
        'total_hours',
        'completed_tasks',
        'total_tasks'
    ];

    protected $casts = [
        'start_date' => 'date',
        'deadline' => 'date'
    ];

    // Relaciones
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function timeTrackings()
    {
        return $this->hasMany(TimeTracking::class);
    }

    // Métodos de ayuda
    public function getCompletedTasksAttribute()
    {
        return $this->timeTrackings()->count(); // O tu lógica específica
    }

    public function getTotalTasksAttribute()
    {
        return $this->timeTrackings()->count() + 5; // Ejemplo
    }

    public function getProgressPercentageAttribute()
    {
        if ($this->total_tasks > 0) {
            return ($this->completed_tasks / $this->total_tasks) * 100;
        }
        return 0;
    }

    public function tasks()
    {
        return $this->hasMany(Task::class);
    }
}
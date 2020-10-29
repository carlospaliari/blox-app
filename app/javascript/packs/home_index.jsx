import React from 'react'
import ReactDOM from 'react-dom'
import "react-big-calendar/lib/css/react-big-calendar.css"
import { Calendar, dateFnsLocalizer } from 'react-big-calendar'
import format from 'date-fns/format'
import parse from 'date-fns/parse'
import startOfWeek from 'date-fns/startOfWeek'
import getDay from 'date-fns/getDay'
import { parseISO } from 'date-fns'
import { useState } from 'react'
import { useEffect } from 'react'

const locales = {
  'en-US': require('date-fns/locale/en-US'),
}
const localizer = dateFnsLocalizer({
  format,
  parse,
  startOfWeek,
  getDay,
  locales,
})

function useEvents() {
  const [events, setEvents] = useState([])
  function loadEvents() {
    fetch("/rooms/1/bookings.json").then(r => r.json()).then(data => {
      setEvents(data.map(e => {
        e.datetime_start = parseISO(e.datetime_start)
        e.datetime_end = parseISO(e.datetime_end)
        return e
      }))
    })
  }
  useEffect(() => {
    loadEvents()
  }, [])

  function updateEventTitle(event) {
    let title = prompt("Update Title", event.title)
    if (title) {
      events.find(e => e.id = event.id).title = title
      setEvents(events.slice())
    }
  }

  function createEvent(slotInfo) {
    let title = prompt("Type the event title")
    if (title) {
      const data = {
        room_id: 1,
        title: title,
        datetime_start: slotInfo.start,
        datetime_end: slotInfo.end,
      }
      fetch("/rooms/1/bookings.json", {
        method: "POST",
        credentials: 'same-origin',
        body: JSON.stringify(data),
        headers: {
          'Content-Type': 'application/json'
        }
      }
      ).then(loadEvents)
    }
  }

  return [events, updateEventTitle, createEvent]
}

function MyCalendar() {
  const [events, updateEventTitle, createEvent] = useEvents()
  return events && <div>
    <Calendar
      localizer={localizer}
      events={events}
      resourceAccessor="id"
      startAccessor="datetime_start"
      endAccessor="datetime_end"
      views={['week']}
      defaultView="week"
      selectable
      onSelectSlot={createEvent}
      onSelectEvent={updateEventTitle}
      style={{ height: '100%' }}
    />
  </div>
}

function HomeIndex() {
  return <MyCalendar />
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <HomeIndex name="React" />,
    document.body.appendChild(document.createElement('div')),
  )
})

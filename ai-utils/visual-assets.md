# Visual Assets & Icons

## Statuses
Use Lucide-react icons for all statuses. Do not use emojis in components.

| Status | Icon | Color class |
|--------|------|-------------|
| Active / פעיל | `CheckCircle` | `text-green-500` |
| Pending / בהמתנה | `Clock` | `text-yellow-500` |
| Canceled / בוטל | `XCircle` | `text-red-500` |
| Completed / בוצע | `CheckCheck` | `text-blue-500` |
| Shipped / נשלח | `Package` | `text-purple-500` |

## Navigation Icons
Use Lucide-react icons exclusively.

| Section | Icon |
|---------|------|
| בית (Home) | `Home` |
| דוחות (Reports) | `BarChart2` |
| לקוחות (Customers) | `Users` |
| הגדרות (Settings) | `Settings` |
| הזמנות (Orders) | `ShoppingCart` |

## Consistency
- Use Lucide-react icons exclusively. Never use emoji as UI indicators in components.
- Icons must match the surrounding text color (`text-*`) and use `className="w-4 h-4"` as the default size.
- Wrap status icons with a colored `<span>` rather than inline styles.

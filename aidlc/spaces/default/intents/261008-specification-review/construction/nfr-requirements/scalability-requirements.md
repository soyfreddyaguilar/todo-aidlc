# Scalability Requirements

**Stage:** NFR Requirements (Construction)
**Unit:** Walking Skeleton (CRUD + localStorage)
**Upstream:** NFR3 (Browser Compatibility — no mention of scaling), Team Practices (no multi-device sync)

---

## Scalability Scope: Skeleton

The walking skeleton is **single-device, single-browser, single-user** by design. Scaling concerns (multi-device sync, backend sharding, CDN) are out of scope for the skeleton.

**Skeleton Constraints:**
- 1 browser session per device
- localStorage quota: typically 5-10 MB per origin
- No server-side infrastructure
- No concurrent user sessions

**Phase 2+ Considerations (Out of Scope for Skeleton):**
- Multi-device sync (service worker, backend sync)
- Multi-user collaboration (requires authentication + server)
- Large-scale task volumes (100k+ tasks per user)

---

## NFR3.1: Single-Session Concurrency

**Requirement:** App must handle reasonable task volumes within a single browser session without degradation.

**Targets:**
- **Task Volume:** Support up to 500 tasks per session (localStorage capacity)
- **Memory Usage:** < 50 MB with 500 tasks loaded
- **Response Time:** Add/edit/delete tasks in < 100 ms regardless of volume

**Rationale:** 500 tasks is realistic for a power user's TODO list; beyond that, localStorage becomes impractical anyway (and multi-device solutions make sense).

**Implementation:**
- No special concurrency controls (browser enforces serialized access to localStorage)
- Efficient filtering: pre-compute filtered lists only on demand (useMemo)
- Pagination/virtualization: defer to Phase 2 if > 1000 tasks needed

**Testing:**
- Load test: create 500 tasks in sequence, measure latency curve
- Memory profile: heap size with 500 tasks loaded
- Responsiveness: verify UI doesn't stall during bulk operations

**Acceptance Criteria:**
- 500 tasks loadable and filterable without UI stall
- Response time remains < 100 ms per operation
- Memory usage stays < 100 MB

---

## NFR3.2: Browser Storage Quota

**Requirement:** Stay well within browser localStorage quota to avoid quota-exceeded errors.

**Targets:**
- **Practical Limit:** Design for 5 MB safe usage (typical browser quota is 5-10 MB)
- **Max Tasks:** ~500 tasks (each task ~10 KB JSON when serialized)
- **Data Structure:** Optimize JSON to minimize size

**Implementation:**
- localStorage key: `todos-app-data`
- No redundant fields or bloated data
- Task schema minimized (e.g., use short field names if optimizing for space)

**Rationale:** For a skeleton, we don't need to optimize for space; clarity is more important. Phase 2 can add compression if needed.

**Monitoring:**
- Calculate total size before saving to localStorage
- Log size to console in development
- Show warning if > 4 MB

**Acceptance Criteria:**
- Typical task set (< 100 tasks) uses < 1 MB
- 500 tasks use < 5 MB (safe margin)

---

## NFR3.3: No Multi-Device Sync

**Requirement:** Explicitly document that multi-device sync is out of scope for skeleton.

**Behavior:**
- Each device/browser has independent task list
- No cloud sync, no real-time updates across devices
- Closing browser window and reopening on different device = different data

**Rationale:** Multi-device sync requires backend API or service worker + sync service. Out of scope for local-storage-only skeleton.

**Documentation:**
- Clearly state in app UI or help text: "Tasks are stored locally on this device only"
- Inform team that Phase 2 addresses multi-device sync

**Acceptance Criteria:**
- No cross-device sync attempted
- App clearly single-device in documentation and UI

---

## Phase 2 Considerations

**Future Scaling Topics (Deferred):**
- Service worker for offline cache and background sync
- Backend API for multi-device sync
- WebSocket for real-time multi-user collaboration
- Pagination/virtualization for 1000+ tasks
- localStorage compression if needed

---

## Traceability

| Inception NFR | Construction Requirement | Status |
|---|---|---|
| NFR3 (Browser Compatibility) | NFR3.1, NFR3.2, NFR3.3 | Detailed (scope clarified) |

**Note:** This stage does NOT introduce new scalability requirements beyond single-device operation. NFR3 in Requirements Analysis is about browser support, not load scaling. Scalability engineering (multi-instance, load balancing) is not applicable to this architecture.


# Migration Workflow

Guide to technology and pattern migrations with rollback planning and dual-run support.

## Overview

Migration workflow handles technology migrations, platform changes, and architecture pattern transitions. Auto-classifies migration type, recommends strategy, and documents rollback procedures for every phase.

**When to use:**
- Migrating technologies (REST → GraphQL, Redux → Zustand)
- Platform changes (Heroku → AWS, MySQL → PostgreSQL)
- Architecture transitions (Monolith → Microservices)
- Upgrading frameworks

## Quick Start

```bash
/ai-sdlc:migration:new "Migrate from REST API to GraphQL"
```

## Workflow Phases (6 Phases)

### Phase 1: Current State Analysis
- Analyze existing implementation
- Document dependencies
- Identify migration scope
- Assess complexity

### Phase 2: Target State Definition
- Define desired architecture
- Identify gaps between current/target
- Determine breaking changes

### Phase 3: Migration Strategy
- **Auto-classify migration type**:
  - Code Migration (e.g., language change)
  - Data Migration (e.g., database change)
  - Architecture Migration (e.g., pattern change)

- **Recommend strategy**:
  - **Incremental**: Migrate piece by piece (lowest risk)
  - **Big Bang**: Migrate everything at once (fastest but risky)
  - **Dual-Run**: Run old & new in parallel (safest for data)
  - **Phased**: Migrate in distinct phases (balanced)

### Phase 4: Rollback Planning
- **Document rollback procedures for EVERY phase**
- Create rollback scripts
- Define rollback triggers
- Test rollback procedures

### Phase 5: Implementation
- Execute migration strategy
- Follow incremental approach
- Test at each milestone
- Document progress

### Phase 6: Cutover Verification
- Verify migration complete
- Compare old vs new functionality
- Check data integrity (for data migrations)
- Run cutover checklist

## Migration Types

### Code Migration
**Example**: TypeScript → Go
- Source code transformation
- API compatibility layer
- Gradual migration

### Data Migration
**Example**: MySQL → PostgreSQL
- Schema transformation
- Data transfer
- **Dual-run** recommended (run both DBs temporarily)
- Verify data integrity

### Architecture Migration
**Example**: Monolith → Microservices
- Pattern transformation
- Service extraction
- Phased migration

## Migration Strategies

### Incremental (Recommended)
```
Week 1: Migrate component A
Week 2: Migrate component B
Week 3: Migrate component C
```
**Pros**: Lowest risk, easy rollback
**Cons**: Slower

### Big Bang
```
Migrate everything in one deployment
```
**Pros**: Fast, clean cut
**Cons**: High risk, hard to rollback

### Dual-Run (For Data)
```
Old DB ← Reads/Writes → Sync → New DB
Monitor for parity
Cut over when confident
```
**Pros**: Safest, can rollback easily
**Cons**: Complex, resource intensive

### Phased
```
Phase 1: Backend migration
Phase 2: Frontend migration
Phase 3: Data migration
```
**Pros**: Organized, manageable
**Cons**: Longer timeline

## Rollback Planning

Every migration phase has rollback procedure:

```markdown
### Phase 3: Migrate User Service

**Implementation**:
1. Deploy new user service
2. Route 10% traffic to new service
3. Monitor for errors

**Rollback Procedure**:
If errors > 5%:
1. Route 100% traffic back to old service
2. Disable new service
3. Investigate errors
4. Fix and retry

**Rollback Trigger**: Error rate > 5% OR latency > 2x baseline
```

## Best Practices

1. **Incremental Wins**: Small steps, frequent validation
2. **Rollback Ready**: Always have rollback plan
3. **Dual-Run for Data**: Run both systems in parallel initially
4. **Monitor Closely**: Watch metrics during migration
5. **Test Rollback**: Practice rolling back before cutover

## Related Resources

- [Command Reference](../../commands/migration/new.md)
- [Skill Documentation](../../skills/migration-orchestrator/SKILL.md)

**Next Steps**: `/ai-sdlc:migration:new [description]`

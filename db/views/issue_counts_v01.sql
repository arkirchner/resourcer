SELECT
  members.id AS member_id,
  COALESCE(assigned_counts.assigned_count, 0) AS assigned_count,
  COALESCE(four_days_assigned_counts.four_days_assigned_count, 0) AS four_days_assigned_count,
  COALESCE(today_assigned_counts.today_assigned_count, 0) AS today_assigned_count,
  COALESCE(overdue_assigned_counts.overdue_assigned_count, 0) AS overdue_assigned_count,
  COALESCE(creator_counts.created_count, 0) AS created_count,
  COALESCE(four_days_created_counts.four_days_created_count, 0) AS four_days_created_count,
  COALESCE(today_created_counts.today_created_count, 0) AS today_created_count,
  COALESCE(overdue_created_counts.overdue_created_count, 0) AS overdue_created_count
FROM members
  LEFT JOIN (
    SELECT
      COUNT(*) AS assigned_count,
      project_members.member_id
    FROM issues
      JOIN project_members ON project_members.id = issues.assignee_id
    GROUP BY
      project_members.member_id
  ) AS assigned_counts ON assigned_counts.member_id = members.id
  LEFT JOIN (
    SELECT
      COUNT(*) AS four_days_assigned_count,
      project_members.member_id
    FROM issues
      JOIN project_members ON project_members.id = issues.assignee_id
    WHERE issues.due_at
      BETWEEN timezone('JST', now())::date AND timezone('JST', now())::date + 4
    GROUP BY
      project_members.member_id
  ) AS four_days_assigned_counts ON four_days_assigned_counts.member_id = members.id
  LEFT JOIN (
    SELECT
      COUNT(*) AS today_assigned_count,
      project_members.member_id
    FROM issues
      JOIN project_members ON project_members.id = issues.assignee_id
    WHERE issues.due_at = timezone('JST', now())::date
    GROUP BY
      project_members.member_id
  ) AS today_assigned_counts ON today_assigned_counts.member_id = members.id
  LEFT JOIN (
    SELECT
      COUNT(*) AS overdue_assigned_count,
      project_members.member_id
    FROM issues
      JOIN project_members ON project_members.id = issues.assignee_id
    WHERE issues.due_at < timezone('JST', now())::date
    GROUP BY
      project_members.member_id
  ) AS overdue_assigned_counts ON overdue_assigned_counts.member_id = members.id
  LEFT JOIN (
    SELECT
      COUNT(*) AS created_count,
      project_members.member_id
    FROM issues
      JOIN project_members ON project_members.id = issues.creator_id
    GROUP BY
      project_members.member_id
  ) AS creator_counts ON creator_counts.member_id = members.id
  LEFT JOIN (
    SELECT
      COUNT(*) AS four_days_created_count,
      project_members.member_id
    FROM issues
      JOIN project_members ON project_members.id = issues.creator_id
    WHERE issues.due_at
      BETWEEN timezone('JST', now())::date AND timezone('JST', now())::date + 4
    GROUP BY
      project_members.member_id
  ) AS four_days_created_counts ON four_days_created_counts.member_id = members.id
  LEFT JOIN (
    SELECT
      COUNT(*) AS today_created_count,
      project_members.member_id
    FROM issues
      JOIN project_members ON project_members.id = issues.creator_id
    WHERE issues.due_at = timezone('JST', now())::date
    GROUP BY
      project_members.member_id
  ) AS today_created_counts ON today_created_counts.member_id = members.id
  LEFT JOIN (
    SELECT
      COUNT(*) AS overdue_created_count,
      project_members.member_id
    FROM issues
      JOIN project_members ON project_members.id = issues.creator_id
    WHERE issues.due_at < timezone('JST', now())::date
    GROUP BY
      project_members.member_id
  ) AS overdue_created_counts ON overdue_created_counts.member_id = members.id

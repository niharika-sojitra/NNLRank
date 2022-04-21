-- Querying the list of projects after filtering based the following criteria:
--        Deleted projects
--        Private projects not having at least 2 watchers and 5 developers
--        Forked projects
--        Projects without a description and projects with description smaller than 5 words. Projects with description containing non-english words 
--        Empty projects where there is no content



select id as project_id, owner_id, name as project_name,description, `language`,created_at, forked_from, deleted
 from  `ghtorrent-bq.ght_2018_04_01.projects` 
            where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
            and (`forked_from` is null) and `deleted`=false 
            and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
            and `id` in 
            (
                select repo_id from ( select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                        where repo_id in
                        (
                            select repo_id from 
                            ( 
                                select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                                group by repo_id
                                having repo_member_count >= 5
                                --order by repo_member_count desc
                            )
                        )
                        group by repo_id
                        having repo_member_count >= 2
                        --order by repo_member_count desc
                    )
            ) 
            and NOT regexp_contains(`description`, '[^ -~]')

-- Querying the repositories associated with the selected list of projects

select * from `ghtorrent-bq.ght_2018_04_01.repo_labels` 
where `id` in 
    (
        select id from  `ghtorrent-bq.ght_2018_04_01.projects` 
        where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
        and (`forked_from` is null) and `deleted`=false 
        and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
        and `id` in 
        (
            select repo_id from ( select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                    where repo_id in
                    (
                        select repo_id from 
                        ( 
                            select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                            group by repo_id
                            having repo_member_count >= 5
                            --order by repo_member_count desc
                        )
                    )
                    group by repo_id
                    having repo_member_count >= 2
                    --order by repo_member_count desc
                )
        ) 
        and NOT regexp_contains(`description`, '[^ -~]')
    ) 


--  Querying the project memebers for the selected projects after filtering users based on following conditions:
--      user is not DELETED
--      user is not marked as FAKE by Github
--      users without any location information

select * from ghtorrent-bq.ght_2018_04_01.users 
where 
`type`='USR' and
`deleted`=false and
`fake`=false and
`location` is not null and 
`id` in 
(
    select user_id from ghtorrent-bq.ght_2018_04_01.project_members 
    where repo_id in
    (
        select `id` from  `ghtorrent-bq.ght_2018_04_01.projects` 
            where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
            and (`forked_from` is null) and `deleted`=false 
            and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
            and `id` in 
            (
                select repo_id from ( select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                        where repo_id in
                        (
                            select repo_id from 
                            ( 
                                select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                                group by repo_id
                                having repo_member_count >= 5
                                --order by repo_member_count desc
                            )
                        )
                        group by repo_id
                        having repo_member_count >= 2
                        --order by repo_member_count desc
                    )
            ) 
            and NOT regexp_contains(`description`, '[^ -~]')
            
    )
)

-- Querying the count of memeber for the selected projects (Feature=Project memeber Count): 

select repo_id as project_id,count(user_id) as project_member_count, from ghtorrent-bq.ght_2018_04_01.project_members 
    where repo_id in
    (
        select `id` from  `ghtorrent-bq.ght_2018_04_01.projects` 
            where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
            and (`forked_from` is null) and `deleted`=false 
            and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
            and `id` in 
            (
                select repo_id from ( select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                        where repo_id in
                        (
                            select repo_id from 
                            ( 
                                select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                                group by repo_id
                                having repo_member_count >= 5
                                --order by repo_member_count desc
                            )
                        )
                        group by repo_id
                        having repo_member_count >= 2
                        --order by repo_member_count desc
                    )
            ) 
            and NOT regexp_contains(`description`, '[^ -~]')
    )
    group by project_id
    order by project_member_count desc;
    
--   Finding Total commit count for each of the selected projects:
 
 select project_id, count(`id`) as commit_count
from `ghtorrent-bq.ght_2018_04_01.commits`
where 
project_id in 
(
    select `id` from  `ghtorrent-bq.ght_2018_04_01.projects` 
            where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
            and (`forked_from` is null) and `deleted`=false 
            and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
            and `id` in 
            (
                select repo_id from ( select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                        where repo_id in
                        (
                            select repo_id from 
                            ( 
                                select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                                group by repo_id
                                having repo_member_count >= 5
                                --order by repo_member_count desc
                            )
                        )
                        group by repo_id
                        having repo_member_count >= 2
                        --order by repo_member_count desc
                    )
            ) 
            and NOT regexp_contains(`description`, '[^ -~]')
)
group by project_id
order by commit_count desc 



-- Find count of commits by each develoepr for the selected project in order to identify successful/failed onboarding. We considered an onboarding was successful if a -- developer made at least 10 commits to the project. It is also used to determine if a project has a star developer or not by calculating the percentage of commits 
-- performed by a member with respect to the total commit count for that project.

select committer_id, project_id, count(`id`) as commit_count
from `ghtorrent-bq.ght_2018_04_01.commits`
where 
committer_id in
(

    select user_id from ghtorrent-bq.ght_2018_04_01.project_members 
        where repo_id in
        (
            select `id` from  `ghtorrent-bq.ght_2018_04_01.projects` 
            where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
            and (`forked_from` is null) and `deleted`=false 
            and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
            and `id` in 
            (
                select repo_id from ( select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                        where repo_id in
                        (
                            select repo_id from 
                            ( 
                                select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                                group by repo_id
                                having repo_member_count >= 5
                                --order by repo_member_count desc
                            )
                        )
                        group by repo_id
                        having repo_member_count >= 2
                        --order by repo_member_count desc
                    )
            ) 
            and NOT regexp_contains(`description`, '[^ -~]')
        )
)

and project_id in 
(
    select `id` from  `ghtorrent-bq.ght_2018_04_01.projects` 
            where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
            and (`forked_from` is null) and `deleted`=false 
            and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
            and `id` in 
            (
                select repo_id from ( select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                        where repo_id in
                        (
                            select repo_id from 
                            ( 
                                select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                                group by repo_id
                                having repo_member_count >= 5
                                --order by repo_member_count desc
                            )
                        )
                        group by repo_id
                        having repo_member_count >= 2
                        --order by repo_member_count desc
                    )
            ) 
            and NOT regexp_contains(`description`, '[^ -~]')
)
group by committer_id, project_id
order by commit_count desc,committer_id desc 
    
-- Querying the first commit and last commit time of each of the selected projects. These will be used to find the features Timecmt0 (From onboarding to first commit time) and Timecmt1 (From onboarding to last commit time):

 select project_id, min(created_at) as first_commit_time, max(created_at) as last_commit_time
  from `ghtorrent-bq.ght_2018_04_01.commits` where `project_id` in
        (
            select `id` from  `ghtorrent-bq.ght_2018_04_01.projects` 
            where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
            and (`forked_from` is null) and `deleted`=false 
            and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
            and `id` in 
            (
                select repo_id from ( select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                        where repo_id in
                        (
                            select repo_id from 
                            ( 
                                select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                                group by repo_id
                                having repo_member_count >= 5
                                --order by repo_member_count desc
                            )
                        )
                        group by repo_id
                        having repo_member_count >= 2
                        --order by repo_member_count desc
                    )
            ) 
            and NOT regexp_contains(`description`, '[^ -~]')
        )
        group by project_id;
        
--  Querying the language ability of each developer for the candiate project (number of the developer’s prior joined projects whose language matches the candidate 
-- project.) For example, if a developer has joined 2 Java projects and 3 PHP projects, and a candidate project is written in Java, then Techlang=2 for this candidate -- project.     

select user_id, language, count(language)
from
(
    select t_members.user_id, t_members.project_id, t_projects.language
	from 
		(
			select user_id from ghtorrent-bq.ght_2018_04_01.project_members 
			where repo_id in
			(
				select `id` from  `ghtorrent-bq.ght_2018_04_01.projects` 
				where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
				and (`forked_from` is null) and `deleted`=false 
				and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
				and `id` in 
				(
					select repo_id from ( select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                        where repo_id in
                        (
                            select repo_id from 
                            ( 
                                select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                                group by repo_id
                                having repo_member_count >= 5
                                --order by repo_member_count desc
                            )
                        )
                        group by repo_id
                        having repo_member_count >= 2
                        --order by repo_member_count desc
                    )
				)
				and NOT regexp_contains(`description`, '[^ -~]')
            
			)
		) as t_members,
		(
			select id as project_id, owner_id, name as project_name,description, `language`,created_at, forked_from, deleted
			from  `ghtorrent-bq.ght_2018_04_01.projects` 
			where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
			and (`forked_from` is null) and `deleted`=false 
			and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
			and `id` in 
            (
                select repo_id from ( select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                        where repo_id in
                        (
                            select repo_id from 
                            ( 
                                select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                                group by repo_id
                                having repo_member_count >= 5
                                --order by repo_member_count desc
                            )
                        )
                        group by repo_id
                        having repo_member_count >= 2
                        --order by repo_member_count desc
                    )
            ) 
            and NOT regexp_contains(`description`, '[^ -~]')
		) as t_projects
    where
    t_members.project_id = t_projects.id
)
group by user_id, language

-- Querying total issue count for each project in the selected list (Feature = Project Issues)

SELECT repo_id,count(distinct(id)) 
FROM `ghtorrent-bq.ght_2018_04_01.issue_labels`
where repo_id in
(
    SELECT `id` from `ghtorrent-bq.ght_2018_04_01.issue_labels` where `repo_id` in
    (
        select `id` from  `ghtorrent-bq.ght_2018_04_01.projects` 
        where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
        and (`forked_from` is null) and `deleted`=false 
        and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
        and `id` in 
        (
            select repo_id from ( select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                    where repo_id in
                    (
                        select repo_id from 
                        ( 
                            select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                            group by repo_id
                            having repo_member_count >= 5
                            order by repo_member_count desc
                        )
                    )
                    group by repo_id
                    having repo_member_count >= 2
                    order by repo_member_count desc
                )
        ) 
        and NOT regexp_contains(`description`, '[^ -~]')
    )
)
group by repo_id;

-- Querying the issue events for selected projects


SELECT * from `ghtorrent-bq.ght_2018_04_01.issue_events` where `issue_id` in
(
    SELECT `id` from `ghtorrent-bq.ght_2018_04_01.issue_labels` where `repo_id` in
    (
        select distinct(`id`) from  `ghtorrent-bq.ght_2018_04_01.projects` 
        where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
        and (`forked_from` is null) and `deleted`=false 
        and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
        and `id` in 
        (
            select distinct(repo_id) from ( select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                    where repo_id in
                    (
                        select repo_id from 
                        ( 
                            select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                            group by repo_id
                            having repo_member_count >= 5
                            order by repo_member_count desc
                        )
                    )
                    group by repo_id
                    having repo_member_count >= 2
                    order by repo_member_count desc
                )
        ) 
        and NOT regexp_contains(`description`, '[^ -~]')
    )
)


-- Querying Organization of each user in the selected list of projects

select * from ghtorrent-bq.ght_2018_04_01.organization_members
where user_id in 
(
    select user_id from ghtorrent-bq.ght_2018_04_01.project_members 
    where repo_id in
    (
        select `id` from  `ghtorrent-bq.ght_2018_04_01.projects` 
            where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
            and (`forked_from` is null) and `deleted`=false 
            and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
            and `id` in 
            (
                select repo_id from 
                (
                    select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                    where repo_id in
                    (
                        select repo_id from 
                        ( 
                            select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                            group by repo_id
                            having repo_member_count >= 5
                            --order by repo_member_count desc
                        )
                    )
                    group by repo_id
                    having repo_member_count >= 2
                        --order by repo_member_count desc
                )
            ) 
            and NOT regexp_contains(`description`, '[^ -~]')
    )
)

-- Query to find out Project first and last membership time for the selected projects (Feature = Time_Meb0 (first member joined since the project creation) and --
-- Time_Meb1 (last member joined since the project creation))


select repo_id as project_id,min(created_at) as first_membership_time,max(created_at) as last_membership_time 
from ghtorrent-bq.ght_2018_04_01.project_members 
    where repo_id in
    (
        select distinct(`id`) from  `ghtorrent-bq.ght_2018_04_01.projects` 
            where (`language`='Java'or `language`='Python' or `language`='JavaScript' or `language`='Ruby' or `language`='PHP'or `language`='C++'or `language`='C'or `language`='C#')
            and (`forked_from` is null) and `deleted`=false 
            and (LENGTH(description) - LENGTH(REPLACE(description, ' ', ''))) >=5 
            and `id` in 
            (
                select repo_id from ( select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.watchers` 
                        where repo_id in
                        (
                            select repo_id from 
                            ( 
                                select repo_id, count(user_id) as repo_member_count from `ghtorrent-bq.ght_2018_04_01.project_members` 
                                group by repo_id
                                having repo_member_count >= 5
                                --order by repo_member_count desc
                            )
                        )
                        group by repo_id
                        having repo_member_count >= 2
                        --order by repo_member_count desc
                    )
            ) 
            and NOT regexp_contains(`description`, '[^ -~]')
    )
    group by project_id;



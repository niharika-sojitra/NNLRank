# Querying the list of projects after filtering based the following criteria:
#       Deleted projects
#       Private projects not having at least 2 watchers and 5 developers
#       Forked projects
#       Projects without a description and projects with description smaller than 5 words. Projects with description containing non-english words 
#       Empty projects where there is no content



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

# Querying the project memebers for the selected projects after filtering users based on following conditions:
#     user is not DELETED
#     user is not marked as FAKE by Github
#     users without any location information

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
    
# Querying the count of memeber for the selected projects: 

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

# Querying the count of memeber for the selected projects (Feature=Project memeber Count): 

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
    
 #Finding Total commit count for the project
 
 







#Find count of commits by each develoepr for the selected project in order to identify successful/failed onboarding. We considered an onboarding was successful if a developer made at least 10 commits to the project

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
    
    

WITH fb_gg_campaign AS (WITH fb_data AS (SELECT fbd.ad_date,
						fc.campaign_name,
						fa.adset_name,
						fbd.spend,
						fbd.impressions,
						fbd.reach,
						fbd.clicks,
						fbd.leads, 
						fbd.value
					FROM facebook_ads_basic_daily fbd 
					LEFT JOIN facebook_campaign fc ON fc.campaign_id = fbd.campaign_id
					LEFT JOIN facebook_adset fa ON fa.adset_id = fbd.adset_id)
			SELECT 	ad_date,
				'Facebook Ads' AS media_source,
				campaign_name, 
				adset_name, 
				spend,
				impressions,
				reach,
				clicks,
				leads,
				value
			FROM fb_data 
			UNION ALL
			SELECT 	ad_date,
				'Google Ads' AS media_source,
				campaign_name, 
				adset_name, 
				spend,
				impressions,
				reach,
				clicks,
				leads,
				value
			FROM google_ads_basic_daily)
SELECT 	ad_date,
	media_source,
	campaign_name,
	adset_name,
	sum(spend) AS total_expences,
	sum(impressions) AS number_of_impressions,
	sum(clicks) AS number_of_clicks,
	sum(value) AS aggregate_value 
FROM 	fb_gg_campaign
GROUP BY ad_date, 
	media_source, 
	campaign_name, 	
	adset_name
ORDER BY 1 asc,2,3,4;

--додаткове завдання
WITH fb_gg_campaign AS (WITH fb_data AS (SELECT fbd.ad_date,
						fc.campaign_name,
						fa.adset_name,
						fbd.spend,
						fbd.impressions,
						fbd.reach,
						fbd.clicks,
						fbd.leads, 
						fbd.value
					FROM facebook_ads_basic_daily fbd 
					LEFT JOIN facebook_campaign fc ON fc.campaign_id = fbd.campaign_id
					LEFT JOIN facebook_adset fa ON fa.adset_id = fbd.adset_id)
			SELECT 	ad_date,
				'Facebook Ads' AS media_source,
				campaign_name, 
				adset_name, 
				spend,
				impressions,
				reach,
				clicks,
				leads,
				value
			FROM fb_data 
			UNION ALL
			SELECT 	ad_date,
				'Google Ads' AS media_source,
				campaign_name, 
				adset_name, 
				spend,
				impressions,
				reach,
				clicks,
				leads,
				value
			FROM google_ads_basic_daily)
SELECT 	campaign_name,
	adset_name,
	sum(spend) AS total_expences,
	round ((sum(value::decimal)/sum(spend::decimal)-1)*100, 2) AS ROMI
FROM fb_gg_campaign
WHERE campaign_name IS NOT NULL 
GROUP BY campaign_name, adset_name
HAVING sum(spend) > 500000
ORDER BY 4 desc;

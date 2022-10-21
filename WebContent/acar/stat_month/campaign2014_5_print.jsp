<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp"%>
<%@ include file="/acar/access_log.jsp" %>


<%
	String loan_st 		= request.getParameter("loan_st")	==null?"":request.getParameter("loan_st");
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw"); //권한
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");//로그인-영업소
	
	
	String save_dt 		= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_bus_cmp");
	
	
	Vector vt = new Vector();
	
	String reg_dt		= "";
	String v_year		= "";
	String v_tm		= "";	
	
	
	if(loan_st.equals("1_1"))	vt = cmp_db.getCampaignList_2014_05_sc1(save_dt, "", "", "");	//20140501 캠페인대상 적용
	else if(loan_st.equals("1_2"))	vt = cmp_db.getCampaignList_2014_05_sc2(save_dt, "", "", "");	//20140501 캠페인대상 적용
	else if(loan_st.equals("2_1"))	vt = cmp_db.getCampaignList_2014_05_sc3(save_dt, "", "", "");	//20140501 캠페인대상 적용
	else if(loan_st.equals("2_2"))	vt = cmp_db.getCampaignList_2014_05_sc4(save_dt, "", "", "");	//20140501 캠페인대상 적용

	//등록일시
	if(vt.size()>0){
		for(int i=0; i<1; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			reg_dt 	= (String)ht.get("REG_DT");
			v_year 	= (String)ht.get("YEAR");
			v_tm 	= (String)ht.get("TM");
		}
	}

	
	//영업캠페인변수 : campaign 테이블
	Hashtable ht3 = cmp_db.getCampaignVar(v_year, v_tm, loan_st);
	
	
	String year 		= (String)ht3.get("YEAR");
	String tm 		= (String)ht3.get("TM");
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");
	String bs_dt 		= (String)ht3.get("BS_DT");
	String be_dt 		= (String)ht3.get("BE_DT");
	String bs_dt2 		= (String)ht3.get("BS_DT2");
	String be_dt2 		= (String)ht3.get("BE_DT2");
	int amt 		= AddUtil.parseInt((String)ht3.get("AMT"));
	int bus_up_per 		= AddUtil.parseInt((String)ht3.get("BUS_UP_PER"));
	int bus_down_per 	= AddUtil.parseInt((String)ht3.get("BUS_DOWN_PER"));
	int mng_up_per 		= AddUtil.parseInt((String)ht3.get("MNG_UP_PER"));
	int mng_down_per 	= AddUtil.parseInt((String)ht3.get("MNG_DOWN_PER"));
	int bus_amt_per 	= AddUtil.parseInt((String)ht3.get("BUS_AMT_PER"));
	int mng_amt_per 	= AddUtil.parseInt((String)ht3.get("MNG_AMT_PER"));
	int new_bus_up_per 	= AddUtil.parseInt((String)ht3.get("NEW_BUS_UP_PER"));
	int new_bus_down_per 	= AddUtil.parseInt((String)ht3.get("NEW_BUS_DOWN_PER"));
	int new_bus_amt_per 	= AddUtil.parseInt((String)ht3.get("NEW_BUS_AMT_PER"));
	int cnt1 		= AddUtil.parseInt((String)ht3.get("CNT1"));
	int mon 		= AddUtil.parseInt((String)ht3.get("MON"));
	String cnt2 		= (String)ht3.get("CNT2");
	float cmp_discnt_per 	= AddUtil.parseFloat((String)ht3.get("CMP_DISCNT_PER"));
	int car_amt 		= AddUtil.parseInt((String)ht3.get("CAR_AMT"));	
	int car_amt2 		= AddUtil.parseInt((String)ht3.get("CAR_AMT2"));	
	int max_dalsung 	= AddUtil.parseInt((String)ht3.get("MAX_DALSUNG"));
	int max_dalsung2 	= AddUtil.parseInt((String)ht3.get("MAX_DALSUNG2"));
	int bus_ga 		= AddUtil.parseInt((String)ht3.get("BUS_GA"));
	int mng_ga 		= AddUtil.parseInt((String)ht3.get("MNG_GA"));
	int bus_new_ga 		= AddUtil.parseInt((String)ht3.get("BUS_NEW_GA"));
	int mng_new_ga 		= AddUtil.parseInt((String)ht3.get("MNG_NEW_GA"));
	String enter_dt		= (String)ht3.get("ENTER_DT");
	String ns_dt1		= (String)ht3.get("NS_DT1");
	String ns_dt2		= (String)ht3.get("NS_DT2");
	String ns_dt3		= (String)ht3.get("NS_DT3");
	String ns_dt4		= (String)ht3.get("NS_DT4");
	String ne_dt1		= (String)ht3.get("NE_DT1");
	String ne_dt2		= (String)ht3.get("NE_DT2");
	String ne_dt3		= (String)ht3.get("NE_DT3");
	String ne_dt4		= (String)ht3.get("NE_DT4");
	int nm_cnt1		= AddUtil.parseInt((String)ht3.get("NM_CNT1"));
	int nm_cnt2		= AddUtil.parseInt((String)ht3.get("NM_CNT2"));
	int nm_cnt3		= AddUtil.parseInt((String)ht3.get("NM_CNT3"));
	int nm_cnt4		= AddUtil.parseInt((String)ht3.get("NM_CNT4"));
	int nb_cnt1		= AddUtil.parseInt((String)ht3.get("NB_CNT1"));
	int nb_cnt2		= AddUtil.parseInt((String)ht3.get("NB_CNT2"));
	int nb_cnt3		= AddUtil.parseInt((String)ht3.get("NB_CNT3"));
	int nb_cnt4		= AddUtil.parseInt((String)ht3.get("NB_CNT4"));	
	int cnt_per		= AddUtil.parseInt((String)ht3.get("CNT_PER"));
	int cost_per		= AddUtil.parseInt((String)ht3.get("COST_PER"));
	int cnt_per2		= AddUtil.parseInt((String)ht3.get("CNT_PER2"));
	int cost_per2		= AddUtil.parseInt((String)ht3.get("COST_PER2"));
	String base_end_dt1	= (String)ht3.get("BASE_END_DT1");
	String base_end_dt2	= (String)ht3.get("BASE_END_DT2");
	int bus_f_per 		= AddUtil.parseInt((String)ht3.get("BUS_F_PER"));
	int mng_f_per 		= AddUtil.parseInt((String)ht3.get("MNG_F_PER"));
	int bus_f_mon 		= AddUtil.parseInt((String)ht3.get("BUS_F_MON"));
	int mng_f_mon 		= AddUtil.parseInt((String)ht3.get("MNG_F_MON"));
	
	
	
	int    sum_amt 		= 0;
	float  sum_c_cnt 	= 0.0f;
	float  sum_cr_cnt	= 0.0f;
	float  sum_c_cost_cnt   = 0.0f;
	float  sum_c_tot_cnt 	= 0.0f;
	float  sum_cmp_discnt_per = 0.0f;
	String avg_dalsung 	= "";
	float avg_cnt 		= 0.0f;
	
	
	
	

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>영업캠페인</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
</head>

<body>
<form name="form1" method="post" action="">
<input type="hidden" name="auth_rw" 	value="<%= auth_rw %>">
<input type="hidden" name="year" 	value="<%= year %>">
<input type="hidden" name="tm" 		value="<%= tm %>">
<input type="hidden" name="vt_size" 	value="<%= vt.size() %>">
<input type="hidden" name="o_cs_dt" 	value="<%=cs_dt%>">
<input type="hidden" name="o_ce_dt" 	value="<%=ce_dt%>">
<input type="hidden" name="s_width" 	value="<%=s_width%>">

<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 캠페인관리 > <span class=style5>통합영업캠페인<%if(!loan_st.equals("")){%>(<%=loan_st%>군)<%}%></span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_campaign.gif align=absmiddle>&nbsp;
          <input type="text" name="cs_dt" size="11" value="<%= AddUtil.ChangeDate2(cs_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
          ~ 
          <input type="text" name="ce_dt" size="11" value="<%= AddUtil.ChangeDate2(ce_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
        </td>
    </tr>
</table>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><div align="right"><img src=../images/center/arrow_gjij.gif align=absmiddle> : <%= reg_dt%></div></td>
    </tr>
</table>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="4%" rowspan="3" class="title">순위</td>
                    <td width="4%" rowspan="3" class="title">구분</td>
                    <td width="7%" rowspan="3" class="title">부서</td>					
                    <td width="6%" rowspan="3" class="title">담당자</td>
                    <td width="6%" rowspan="3" class="title">평가기준</td>
                    <td colspan="5" class="title">캠페인 실적</td>
                    <td width="8%" rowspan="3" class="title">포상금액</td>
                    <td width="30%" rowspan="3">
        			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
        				<tr style='text-align:right'>
        				  <td class="title_p" width="50%" style='height:66; text-align:right;'>100</td>
        				  <td class="title_p" width="50%" style='text-align:right;'>200</td>
        				</tr>
        			  </table>
       			  </td>
                </tr>
                <tr> 
                    <td colspan="2" class="title">영업대수</td>
                    <td width="7%" rowspan="2" class="title">영업효율<br>대수</td>
                    <td width="7%" rowspan="2" class="title">캠페인실적</td>
                    <td width="7%" rowspan="2" class="title">달성율</td>
                </tr>
                <tr>
                    <td width="7%" class="title">총실적</td>
                    <td width="7%" class="title">유효실적</td>
                </tr>
                <%	if(vt.size()>0){
				for(int i=0; i<vt.size(); i++){
				
					Hashtable ht2 = (Hashtable)vt.elementAt(i);
					
					String dept_id 		= (String)ht2.get("DEPT_ID");
					float graph = 0;
					
					if(!String.valueOf(ht2.get("DALSUNG")).equals("")){
						sum_cmp_discnt_per 	+= AddUtil.parseFloat((String)ht2.get("CMP_DISCNT_PER"));
						sum_c_cnt 		+= AddUtil.parseFloat((String)ht2.get("C_CNT"));
						sum_cr_cnt 		+= AddUtil.parseFloat((String)ht2.get("CR_CNT2"));
						sum_amt 		+= AddUtil.parseInt((String)ht2.get("AMT2"));
						sum_c_cost_cnt		+= AddUtil.parseFloat((String)ht2.get("ORG_C_COST_CNT"));
						sum_c_tot_cnt		+= AddUtil.parseFloat((String)ht2.get("C_TOT_CNT"));
						if(i==0){
							avg_dalsung 	= (String)ht2.get("AVG_DALSUNG");
						}
						avg_cnt++;	
						
						graph 		= AddUtil.parseFloat((String)ht2.get("DALSUNG"))*150/100;
					}
																				
					if(graph >300)		graph = 300;
					
					String loan_st_nm 	= (String)ht2.get("LOAN_ST_NM");
					String u_enter_dt 	= (String)ht2.get("ENTER_DT");
					
					if(AddUtil.parseInt(u_enter_dt) >= AddUtil.parseInt(ns_dt1)) loan_st_nm = "신입";
		 %>
                <tr> 
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><%= loan_st_nm %></td>
                    <td align="center"><%= ht2.get("NM_CD") %></td>					
                    <td align="center"><%= ht2.get("USER_NM") %></td>
                    <td align="<% if(auth_rw.equals("6")) out.print("right"); else out.print("center"); %>"> 
                      <% if(auth_rw.equals("6")){ %>
                      <%= ht2.get("CMP_DISCNT_PER") %>
                      <% }else{ %>
                      미공개 
                      <% } %>
                    </td>
                    <td align="right"><%= ht2.get("C_CNT") %></td>
                    <td align="right"><%= ht2.get("CR_CNT2") %></td>
                    <td align="right"><%= ht2.get("C_COST_CNT") %></td>
                    <td align="right"><%= ht2.get("C_TOT_CNT") %></td>
                    <td align="right"><%= ht2.get("ORG_DALSUNG") %></td>
                    <td align="right"><%= AddUtil.parseDecimal((String)ht2.get("AMT2")) %></td>
                    <td align=""><img src=../../images/result1.gif width=<%= graph %> height=10><%if(String.valueOf(ht2.get("DALSUNG")).equals("")){%>미적용 (편입기준 불충족)<%}%></td>
                </tr>
          <% 			}
			 }%>
                <tr> 
                    <td class="title" colspan=4>합계</td>                             
                    <td class="title" style='text-align:right'><% if(auth_rw.equals("6")){ %><%= AddUtil.parseFloatCipher(sum_cmp_discnt_per,2) %><% } %></td>
                    <td class="title" style='text-align:right'><%= Math.round(sum_c_cnt*1000)/1000f %>&nbsp;&nbsp;&nbsp;</td>
                    <td class="title" style='text-align:right'><%= Math.round(sum_cr_cnt*1000)/1000f %></td>
                    <td class="title" style='text-align:right'><%= Math.round(sum_c_cost_cnt*1000)/1000f %>&nbsp;&nbsp;&nbsp;</td>
                    <td class="title" style='text-align:right'><%= Math.round(sum_c_tot_cnt*1000)/1000f %></td>
                    <td class="title" style='text-align:right'></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseDecimal(sum_amt) %></td>
                    <td class="title" style='text-align:left'>&nbsp;미적용 제외</td>
                </tr>
                <tr> 
                    <td class="title" colspan=4>평균</td>                             
                    <td class="title" style='text-align:right'><% if(auth_rw.equals("6")){ %><%= AddUtil.parseFloatCipher(sum_cmp_discnt_per/avg_cnt,2) %><% } %></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher(sum_c_cnt/avg_cnt,2) %>&nbsp;&nbsp;&nbsp;</td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher(sum_cr_cnt/avg_cnt,2) %></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher(sum_c_cost_cnt/avg_cnt,2) %>&nbsp;&nbsp;&nbsp;</td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher(sum_c_tot_cnt/avg_cnt,2) %></td>
                    <td class="title" style='text-align:right'><%= avg_dalsung %></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(sum_amt/avg_cnt))) %></td>
                    <td class="title" style='text-align:left'>&nbsp;미적용 제외</td>
                </tr>         			                
          </table>
  	</td>
    </tr>
</table>
</form>
</body>
</html>
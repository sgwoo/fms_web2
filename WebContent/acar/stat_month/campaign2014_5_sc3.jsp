<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.stat_bus.*, acar.estimate_mng.*, acar.user_mng.*"%>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp"%>
<%@ include file="/acar/access_log.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();


	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw"); 	//권한
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");	//로그인-ID
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");	//로그인-영업소
	
	
	String save_dt 		= request.getParameter("save_dt")	==null?"":request.getParameter("save_dt");
	
	
	//권한
	auth_rw = rs_db.getAuthRw(user_id, "09", "05", "12");
	
	
	//마감일자
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_bus_cmp");
	
			
	String reg_dt		= "";
	int    sum_amt 		= 0;
	float sum_c_cnt 	= 0.0f;
	float sum_cr_cnt	= 0.0f;
	float sum_c_cost_cnt	= 0.0f;
	float sum_c_tot_cnt	= 0.0f;
	float sum_cmp_discnt_per= 0.0f;
	float sum_org_dalsung	= 0.0f;
	String avg_dalsung 	= "";
	float avg_cnt 		= 0.0f;
	String v_year		= "";
	String v_tm		= "";
	
	
	Vector vt = cmp_db.getCampaignList_2014_05_sc3(save_dt, "", "", "");//20140201 영업대수,유효실적,적용실적 적용, 영업대리인/영업담당자 실적배분 변경
	
	
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
	Hashtable ht3 = cmp_db.getCampaignVar(v_year, v_tm, "2_1");
	
	String year 		= (String)ht3.get("YEAR");
	String tm 		= (String)ht3.get("TM");
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");
	String bs_dt 		= (String)ht3.get("BS_DT");
	String be_dt 		= (String)ht3.get("BE_DT");
	int up_per 		= AddUtil.parseInt((String)ht3.get("UP_PER"));
	int down_per 		= AddUtil.parseInt((String)ht3.get("DOWN_PER"));
	int amt_per 		= AddUtil.parseInt((String)ht3.get("AMT_PER"));
	int car_amt 		= AddUtil.parseInt((String)ht3.get("CAR_AMT"));	
	int max_dalsung 	= AddUtil.parseInt((String)ht3.get("MAX_DALSUNG"));
	int min_dalsung 	= AddUtil.parseInt((String)ht3.get("MIN_DALSUNG"));
	int ga 			= AddUtil.parseInt((String)ht3.get("GA"));
	int new_ga 		= AddUtil.parseInt((String)ht3.get("NEW_GA"));
	String ns_dt1		= (String)ht3.get("NS_DT1");
	String ns_dt2		= (String)ht3.get("NS_DT2");
	String ns_dt3		= (String)ht3.get("NS_DT3");
	String ns_dt4		= (String)ht3.get("NS_DT4");
	String ne_dt1		= (String)ht3.get("NE_DT1");
	String ne_dt2		= (String)ht3.get("NE_DT2");
	String ne_dt3		= (String)ht3.get("NE_DT3");
	String ne_dt4		= (String)ht3.get("NE_DT4");
	int n_cnt1		= AddUtil.parseInt((String)ht3.get("N_CNT1"));
	int n_cnt2		= AddUtil.parseInt((String)ht3.get("N_CNT2"));
	int n_cnt3		= AddUtil.parseInt((String)ht3.get("N_CNT3"));
	int n_cnt4		= AddUtil.parseInt((String)ht3.get("N_CNT4"));
	int cnt_per		= AddUtil.parseInt((String)ht3.get("CNT_PER"));
	int cost_per		= AddUtil.parseInt((String)ht3.get("COST_PER"));
	String base_end_dt1	= (String)ht3.get("BASE_END_DT1");
	String base_end_dt2	= (String)ht3.get("BASE_END_DT2");
	
	int not_cmp_cnt = 0;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>영업캠페인</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		

	//프린트화면보기
	function cmp_print(){
		window.open("campaign2014_5_print.jsp?loan_st=2_1&save_dt=<%=save_dt%>&auth_rw=<%=auth_rw%>","print","left=30,top=50,width=1050,height=850,scrollbars=yes");	
	}
	
	//계산식보기 --2군서울
	function view_sik(){
		window.open("campaign2014_5_sik.jsp?loan_st=2_1&save_dt=<%=save_dt%>&bus_down_per=<%=down_per%>&mng_down_per=<%=down_per%>&cs_dt=<%=cs_dt%>&ce_dt=<%=ce_dt%>&bs_dt=<%=bs_dt%>&be_dt=<%=be_dt%>&bs_dt2=<%=bs_dt%>&be_dt2=<%=be_dt%>&enter_dt=<%=ns_dt1%>","sik","left=30,top=50,width=1050,height=600,scrollbars=yes");
	}
	
	//변수수정
	function updateVar(){
		var fm = document.form1;
		if(!confirm("변수값을 수정하시겠습니까?"))	return;	
		fm.action = "campaign2014_5_Var3_iu.jsp";
		fm.target = 'i_no';
//		fm.target = '_blank';	
		fm.submit();
	}	
//-->
</script>
</head>

<body>
<form name="form1" method="post" action="/acar/stat_month/campaign2014_5_sc3.jsp">
<input type="hidden" name="auth_rw" 	value="<%= auth_rw %>">
<input type="hidden" name="user_id" 	value="<%= user_id %>">
<input type="hidden" name="br_id" 	value="<%= br_id %>">
<input type="hidden" name="year" 	value="<%= year %>">
<input type="hidden" name="tm" 		value="<%= tm %>">
<input type="hidden" name="vt_size" 	value="<%= vt.size() %>">
<input type="hidden" name="from_page" 	value="/acar/stat_month/campaign2014_5_sc3.jsp">
<input type="hidden" name="o_cs_dt" 	value="<%=cs_dt%>">
<input type="hidden" name="o_ce_dt" 	value="<%=ce_dt%>">
<input type="hidden" name="s_width" 	value="<%=s_width%>">
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 캠페인관리 > <span class=style5>영업캠페인(2군 서울.인천)</span></span></td>
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
	  <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
	    &nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:cmp_print()' title='프린트하기'><img src=../images/center/button_print.gif align=absmiddle border=0></a>
	  <%}%>
	</td>
    </tr>
</table>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><div align="right"><img src=../images/center/arrow_gjij.gif align=absmiddle> : <%= reg_dt%> (실달성율순)</div></td>
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
                  <td width="7%" class="title">적용실적</td>
                </tr>
                <% if(vt.size()>0){
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
						sum_org_dalsung		+= AddUtil.parseFloat((String)ht2.get("ORG_DALSUNG"));
						if(i==0 || avg_dalsung.equals("")){
							avg_dalsung 	= (String)ht2.get("AVG_DALSUNG");
						}
						avg_cnt++;	
						
						graph 		= AddUtil.parseFloat((String)ht2.get("ORG_DALSUNG"))*150/100;	
					}
										
					String loan_st_nm 	= (String)ht2.get("LOAN_ST_NM");
					String u_enter_dt 	= (String)ht2.get("ENTER_DT");
					
					if(graph >300)							graph 		= 300;
					if(AddUtil.parseInt(u_enter_dt) >= AddUtil.parseInt(ns_dt1)) 	loan_st_nm 	= "신입";
					if(loan_st_nm.equals("2군"))					loan_st_nm 	= "<font color=red>2군</font>";
					
					if(String.valueOf(ht2.get("DALSUNG")).equals("")){
						not_cmp_cnt++;
					}					
					
		 %>
                <tr> 
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><%= ht2.get("NM_CD") %></td>					
                    <td align="center"><%= ht2.get("USER_NM") %></td>
                    <td align="<% if(auth_rw.equals("6")) out.print("right"); else out.print("center"); %>"><% if(auth_rw.equals("6")){ %><%= ht2.get("CMP_DISCNT_PER") %><% }else{ %>미공개<% } %></td>
                    <td align="right"><%= ht2.get("C_CNT") %><a href="javascript:MM_openBrWindow('campaign2014_5_list_id.jsp?user_nm=<%= ht2.get("USER_NM") %>&bus_id=<%= ht2.get("USER_ID") %>&cs_dt=<%= AddUtil.ChangeDate2(cs_dt) %>&ce_dt=<%= AddUtil.ChangeDate2(ce_dt) %>&bs_dt=<%= bs_dt %>&be_dt=<%= be_dt %>','list_id','scrollbars=yes,status=no,resizable=yes,width=1100,height=860,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a></td>
                    <td align="right"><%= ht2.get("CR_CNT2") %></td>
                    <td align="right"><%= ht2.get("C_COST_CNT") %><a href="javascript:MM_openBrWindow('campaign2014_5_list_id_cost.jsp?save_dt=<%=save_dt%>&user_nm=<%= ht2.get("USER_NM") %>&bus_id=<%= ht2.get("USER_ID") %>&cs_dt=<%= AddUtil.ChangeDate2(cs_dt) %>&ce_dt=<%= AddUtil.ChangeDate2(ce_dt) %>&bs_dt=<%= bs_dt %>&be_dt=<%= be_dt %>','list_id','scrollbars=yes,status=no,resizable=yes,width=1060,height=560,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a></td>
                    <td align="right"><%= ht2.get("C_TOT_CNT") %></td>
                    <td align="right"><%= ht2.get("ORG_DALSUNG") %></td>
                    <td align="right"><%= AddUtil.parseDecimal((String)ht2.get("AMT2")) %></td>
                    <td align=""><img src=../../images/result1.gif width=<%= graph %> height=10><%if(String.valueOf(ht2.get("DALSUNG")).equals("")){%>미적용 (편입기준 불충족 <%if(String.valueOf(ht2.get("USER_ID")).equals("000076")){%>-장기휴가<%}%>)<%}%></td>
                </tr>
                <% 		}
		  }%>
                <tr> 
                    <td class="title" colspan=3>합계</td>         
                    <td class="title" style='text-align:right'><% if(auth_rw.equals("6")){ %><%= AddUtil.parseFloatCipher(sum_cmp_discnt_per,2) %><% } %></td>
                    <td class="title" style='text-align:right'><%= Math.round(sum_c_cnt*1000)/1000f %>&nbsp;&nbsp;&nbsp;</td>
                    <td class="title" style='text-align:right'><%= Math.round(sum_cr_cnt*1000)/1000f %></td>
                    <td class="title" style='text-align:right'><%= Math.round(sum_c_cost_cnt*1000)/1000f %>&nbsp;&nbsp;&nbsp;</td>
                    <td class="title" style='text-align:right'><%= Math.round(sum_c_tot_cnt*1000)/1000f %></td>
                    <td class="title" style='text-align:right'></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseDecimal(sum_amt) %></td>
                    <td class="title" style='text-align:left'>&nbsp;<%if(not_cmp_cnt > 0){%>미적용 제외<%}%></td>
                </tr>
                <tr> 
                    <td class="title" colspan=3>평균</td>         
                    <td class="title" style='text-align:right'><% if(auth_rw.equals("6")){ %><%= AddUtil.parseFloatCipher(sum_cmp_discnt_per/avg_cnt,2) %><% } %></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher(sum_c_cnt/avg_cnt,2) %>&nbsp;&nbsp;&nbsp;</td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher(sum_cr_cnt/avg_cnt,2) %></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher(sum_c_cost_cnt/avg_cnt,2) %>&nbsp;&nbsp;&nbsp;</td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher(sum_c_tot_cnt/avg_cnt,2) %></td>
                    <td class="title" style='text-align:right'><%= avg_dalsung %></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(sum_amt/avg_cnt))) %></td>
                    <td class="title" style='text-align:left'>&nbsp;<%if(not_cmp_cnt > 0){%>미적용 제외&nbsp;(실달성율 평균:<%= AddUtil.parseFloatCipher(sum_org_dalsung/avg_cnt,2) %>)<%}%></td>
                </tr>                
          </table>
  	    </td>
    </tr>
</table>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><p><font color="#999999"><br>
          ♣ 유효실적 : 대량수요의 경우 5대 초과 분은 50%로 할인하고 동일업체에 대해 최대 10대까지 실적인정.<br>
		  ♣ 캠페인실적 : (캠페인기간 영업대수 유효실적대수 * 영업대수가중치) + (캠페인기간 영업효율대수 유효실적대수 * 영업효율대수가중치)<br>
		  ♣ 달성률 : 캠페인실적 / 평가기준
		  </font></p>
        </td>
    </tr>
</table>
  <br>
  <% if(auth_rw.equals("6")){ %>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td width="100">1. 평가기준기간</td>
        <td>: 2군(영업)
        <input type="text" name="bs_dt" size="11" value="<%= AddUtil.ChangeDate2(bs_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
		~
		<input type="text" name="be_dt" size="11" value="<%= AddUtil.ChangeDate2(be_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'></td>
    </tr>
    <tr id=tr_a style='display:none'> 
        <td>&nbsp;</td>
        <td>: 전전분기마감
		<input type="text" name="base_end_dt1" size="11" value="<%= AddUtil.ChangeDate2(base_end_dt1) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
		, 전분기마감
		<input type="text" name="base_end_dt2" size="11" value="<%= AddUtil.ChangeDate2(base_end_dt2) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
		</td>
    </tr>		
    <tr> 
        <td>2. 기준금액</td>
        <td>: 
        <input type="text" name="amt" size="11" value="" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value)'>
		원 =
		<input type="text" name="car_amt" size="11" value="<%= AddUtil.parseDecimal(car_amt) %>" class=num onBlur='javascript:getR_cnt(); this.value=parseDecimal(this.value)'>
		*
		<input type="text" name="total_car" size="5" value="" class=whitenum >
		(캠페인실적 합계)
		</td>
    </tr>
    <tr> 
        <td>3. 평균계산달성율 </td>
        <td>: 
        최대 <input type="text" name="max_dalsung" size="4" value="<%= AddUtil.parseDecimal(max_dalsung) %>" class=num >
		%
	/ 
	최소 <input type="text" name="min_dalsung" size="4" value="<%= AddUtil.parseDecimal(min_dalsung) %>" class=num >
		%	
		</td>
    </tr>
    <tr> 
        <td>4. 대수가중치 </td>
        <td>: 영업대수
        <input type="text" name="cnt_per" size="4" value="<%= AddUtil.parseDecimal(cnt_per) %>" class=num >
		%, 영업효율대수
		<input type="text" name="cost_per" size="4" value="<%= AddUtil.parseDecimal(cost_per) %>" class=num >
		%
		</td>		
    </tr>	
    <tr> 
        <td>5. 할인치</td>
        <td>: 2군(영업) &nbsp;&nbsp;&nbsp;평균상회대수 
        <input type="text" name="up_per" size="3" value="<%= AddUtil.parseDecimal(up_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
        % 반영, 평균 
        <input type="text" name="down_per" size="3" value="<%= AddUtil.parseDecimal(down_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
        % 미달자 <%= AddUtil.parseDecimal(down_per) %>% 반영, 평균과 평균 <%= AddUtil.parseDecimal(down_per) %>% 
        사이는 자기평균치 반영,
		신입사원 - 군 평균 <input type="text" name="new_ga" size="3" value="<%= AddUtil.parseDecimal(new_ga) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
		% 반영
		</td>
    </tr>

    <tr> 
        <td>6. 할인치 가중치</td>
        <td>: 2군(영업)
        <input type="text" name="ga" size="3" value="<%= AddUtil.parseDecimal(ga) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
		% </td>
    </tr>
    <tr> 
        <td>7. 포상금액 적용율</td>
        <td>: 2군(영업)
        <input type="text" name="amt_per" size="3" value="<%= AddUtil.parseDecimal(amt_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
		%</td>
    </tr>
    <tr id=tr_f1 style='display:none'> 
        <td>8. 신입사원</td>
        <td>: 입사일 
        <input name="ns_dt1" type="text" class=default id="ns_dt1" onBlur='javascript:this.value=ChangeDate(this.value)' value="<%= AddUtil.ChangeDate2(ns_dt1) %>" size="11">
        ~
        <input name="ne_dt1" type="text" class=text id="ne_dt1" onBlur='javascript:this.value=ChangeDate(this.value)' value="<%= AddUtil.ChangeDate2(ne_dt1) %>" size="11">
        , 2군(영업) 기준실적 
        <input name="nb_cnt1" type="text" class=num id="n_cnt1" onBlur='javascript:this.value=parseDecimal(this.value)' value="<%= n_cnt1 %>" size="3">
		대 <font color=red>(신입사원 기준일자)</font></td>
    </tr>
    <tr id=tr_f2 style='display:none'> 
        <td>&nbsp;</td>
        <td>: 입사일 
        <input name="ns_dt2" type="text" class=text id="ns_dt2" onBlur='javascript:this.value=ChangeDate(this.value)' value="<%= AddUtil.ChangeDate2(ns_dt2) %>" size="11">
        ~
        <input name="ne_dt2" type="text" class=text id="ne_dt2" onBlur='javascript:this.value=ChangeDate(this.value)' value="<%= AddUtil.ChangeDate2(ne_dt2) %>" size="11">
        , 2군(영업) 기준실적 
        <input name="nb_cnt2" type="text" class=num id="n_cnt2" onBlur='javascript:this.value=parseDecimal(this.value)' value="<%= n_cnt2 %>" size="3">
		대</td>
    </tr>
    <tr id=tr_f3 style='display:none'> 
        <td>&nbsp;</td>
        <td>: 입사일 
        <input name="ns_dt3" type="text" class=text id="ns_dt3" onBlur='javascript:this.value=ChangeDate(this.value)' value="<%= AddUtil.ChangeDate2(ns_dt3) %>" size="11">
        ~
        <input name="ne_dt3" type="text" class=text id="ne_dt3" onBlur='javascript:this.value=ChangeDate(this.value)' value="<%= AddUtil.ChangeDate2(ne_dt3) %>" size="11">
        , 2군(영업) 기준실적 
        <input name="nb_cnt3" type="text" class=num id="n_cnt3" onBlur='javascript:this.value=parseDecimal(this.value)' value="<%= n_cnt3 %>" size="3">
		대</td>
    </tr>
    <tr id=tr_f4 style='display:none'> 
        <td>&nbsp;</td>
        <td>: 입사일 
        <input name="ns_dt4" type="text" class=text id="ns_dt4" onBlur='javascript:this.value=ChangeDate(this.value)' value="<%= AddUtil.ChangeDate2(ns_dt4) %>" size="11">
        ~
        <input name="ne_dt4" type="text" class=text id="ne_dt4" onBlur='javascript:this.value=ChangeDate(this.value)' value="<%= AddUtil.ChangeDate2(ne_dt4) %>" size="11">
        , 2군(영업) 기준실적 
        <input name="nb_cnt4" type="text" class=num id="n_cnt4" onBlur='javascript:this.value=parseDecimal(this.value)' value="<%= n_cnt4 %>" size="3">
		대</td>
    </tr>	
</table>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td width="900" colspan="2">8. 계산식보기==&gt; <a href="javascript:view_sik();"><img src=../images/center/button_see.gif align=absmiddle border=0></a> 
        </td>
        <td width="100"><a href='javascript:updateVar()'><img src=../images/center/button_modify.gif align=absmiddle border=0></a></td>
    </tr>
</table>
  <% }else{ %>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr>		
        <td>&nbsp;</td>
    </tr>
</table>
  <% } %>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<% if(auth_rw.equals("6")){ %>
<script language="javascript">
<!--	
	document.form1.total_car.value 	= "<%= AddUtil.parseFloatCipher(sum_c_tot_cnt,2) %>";	
	document.form1.amt.value 	= "<%= AddUtil.parseDecimal(Math.round(car_amt*sum_c_tot_cnt/1000)*1000) %>";
//-->
</script>
<% } %>
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.secondhand.*, acar.insur.*, acar.memo.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	int idx = 0;	
	
	//관리현황
	Vector deb1s = ad_db.getStatDebtList("stat_rent_month");
	int deb1_size = deb1s.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function popup(url, table_width)
	{
		var fm = document.form1;
		fm.table_width.value = table_width;		
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}	

function popup3()
{
	var fm = document.form1;				
	fm.target = '_blank';
	
	if(fm.stat_st.value == '1') 		fm.action = 'select_stat_end_1year_end_grt_list_db.jsp';
	if(fm.stat_st.value == '2') 		fm.action = 'select_stat_end_1year_end_debt_list_db.jsp';
	if(fm.stat_st.value == '3') 		fm.action = 'select_stat_end_cont_fee_list_db.jsp';
	if(fm.stat_st.value == '') 			return;
							
	fm.submit();
}	

function popup4()
{
	var fm = document.form1;				
	fm.target = '_blank';
	
	if(fm.stat_st.value == '1') 		fm.action = 'select_stat_end_1year_end_grt_list_db_e.jsp';
	if(fm.stat_st.value == '2') 		fm.action = 'select_stat_end_1year_end_debt_list_db_s.jsp';
	if(fm.stat_st.value == '3') 		fm.action = 'select_stat_end_cont_fee_list_db_s.jsp';
	if(fm.stat_st.value == '') 			return;
							
	fm.submit();
}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='table_width' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    <td colspan=10>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
          <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
          <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>결산관련자료</span></span></td>
          <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td class=h></td>
  </tr>
  <tr>
    <td class=h></td>
  </tr>
  <tr>
    <td class=h></td>
  </tr>
  <tr>
    <td class=h></td>
  </tr>

  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※ <b>결산기준년도</b> - <input type='text' size='4' name='settle_year' maxlength='4' class='default' value='<%=AddUtil.getDate2(1)-1%>'>
		  년도
	  </td>
  </tr>
  <tr>
	  <td>&nbsp;</td>
  </tr>
  <tr>
	  <td>&nbsp;</td>
  </tr>
  <!--1-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 자동차보험료 전년대비 지급현황 
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list1.jsp','1210')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
			&nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel1.jsp','1210')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>
  <tr>
	  <td>&nbsp;</td>
  </tr>
  <!--2-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 할부금 미지급비용 (1월 지급예정 중 할부기간 12월에 걸친 이자비용 미지급처리) - 미지급비용_이자
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list2.jsp','1350')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>	
			&nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel2.jsp','1350')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>
  <tr>
	  <td>&nbsp;</td>
  </tr>
  <!--3-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 영업사원수당 지급현황 
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list3.jsp','1750')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>	
			&nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel3.jsp','1750')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  		   
	  </td>
  </tr>
  <tr>
	  <td>&nbsp;</td>
  </tr>
  <!--4-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 계약 보증금 리스트 - 장기대여보증금
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list4.jsp','1700')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel4.jsp','1700')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
		  &nbsp;&nbsp;거래처별 :		  
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list4_client.jsp','850')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel4_client.jsp','850')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
		</td>
  </tr>
  <tr>
	  <td>&nbsp;</td>
  </tr>
  <!--5-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 차입금 현황 (총무팀장)
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list5.jsp','1100')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel5.jsp','1100')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>
  <tr>
	  <td>&nbsp;</td>
  </tr>
  <!--6-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 선급보험료 기간비용 월별 점검 <select name='insurgubun'><option value = "1">영업용</option><option value = "2">업무용</option></select> 월별 조회 <input type='text' size='8' name='insurmmyy1' maxlength='6'  value='' placeholder="ex)201601">
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list6.jsp','450')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
			&nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel6.jsp','450')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>
  <!--7-->
  <%idx++;%>
  
  <tr>
	  <td>&nbsp;</td>
  </tr>
  <!--8-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 계산서 발행리스트 - 개시대여료 
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list8.jsp','1050')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel8.jsp','1050')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>  
  <tr>
	  <td>&nbsp;</td>
  </tr>
  <!--9-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 계산서 발행리스트 - 대여료 - 미회수채권리스트
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list9.jsp','800')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel9.jsp','800')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>
  
  <!-- 20200107 추가작업 -->
  <!--10-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 계약 개시대여료 리스트 (연도별 만기리스트)
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list10.jsp','1810')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel10.jsp','1810')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;거래처별 :		  
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list10_client.jsp','970')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel10_client.jsp','970')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>
  
  <!--11-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 계약 선납금 리스트 (연도별 만기리스트)
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list11.jsp','1810')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel11.jsp','1810')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;거래처별 :		  
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list11_client.jsp','970')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel11_client.jsp','970')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>
  
  <!--12-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 계약 선납금 년도별 금액 (선수대여료스케줄) - 선수대여료_선납금일시 
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list12.jsp','1700')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel12.jsp','1700')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>
  
  <!--13-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 계약 개시대여료 년도별 금액 (선수대여료스케줄) - 선수대여료_개시대여료
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list13.jsp','1700')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel13.jsp','1700')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>
  
  <!--14-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 계약 대여료일시납 년도별 금액 (선수대여료스케줄) - 선수대여료_일시납
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list14.jsp','1700')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel14.jsp','1700')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>
      
      
  <!--15-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 계산서 발행리스트 - 선납금
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list15.jsp','800')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel15.jsp','800')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>
  
  <!--16-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 결산년도 1월 대여료청구리스트 사용기간 년도별금액 
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list16.jsp','1550')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel16.jsp','1550')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>
  
  <!--17-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 결산익년 1월 대여료청구리스트 사용기간 년도별금액 - 미수대여료
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list17.jsp','1550')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel17.jsp','1550')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>  
  
  <!--17-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 결산익년 2월 대여료청구리스트 사용기간 년도별금액 - 미수대여료
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list17_2.jsp','1550')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel17_2.jsp','1550')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>    
  
  <!--18-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 결산년도 대여료청구리스트 사용기간 2달이상 
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list18.jsp','1250')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel18.jsp','1250')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>    
        
  <!--19-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 계산서 발행리스트 - 해지 - 미회수채권리스트 
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list19.jsp','800')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel19.jsp','800')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>    
        
  <!--20-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 결산년도 1월1일이후 계약 만기리스트 
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list20.jsp','1050')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel20.jsp','1050')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>    
        
  <!--21-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 보증보험 가입현황 
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list21.jsp','1050')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  
		  &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel21.jsp','1050')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>		  
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>    
  
  <!--22-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 대여&리스 연도별 수금계획 
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list22.jsp','800')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		  		 	 
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>      
  <!--23-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 미사용연차현황 
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list23.jsp','900')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>	
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel23.jsp','900')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>	  		 	 
	  </td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>       
  <!--24
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%//idx++;%><%//=idx%>. 계약현황 
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list24.jsp','1150')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>	
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list_excel24.jsp','1150')"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>	  		 	 
	  </td>
  </tr> 
  -->   
  <!--25-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 카드캐쉬백입금현황 
	    &nbsp;&nbsp;<a href="javascript:popup('settle_account_list25.jsp','870')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		    	  		 	 
	  </td>
  </tr>      
  <tr>
	  <td>&nbsp;</td>
  </tr>                       
  <tr>
	<td>&nbsp;</td>
  </tr>
  
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※ <b>DB 월마감 보기</b> - 
		<select name="save_dt">
			<%	if(deb1_size > 0){
				    for(int i = 0 ; i < deb1_size ; i++){
						StatDebtBean sd = (StatDebtBean)deb1s.elementAt(i);%>		
			<option value="<%=sd.getSave_dt()%>">[<%=sd.getSave_dt()%>] <%=sd.getReg_dt()%></option>		
			<%		}
				}%>
		</select>
		<select name="stat_st">
			<option value="">선택</option>		
			<%if(ck_acar_id.equals("000029")){ %>
			<option value="1">유동성장기보증금(1년이내도래분)</option>			
			<option value="2">유동성장기차입금(1년이내도래분)</option>
			<%}%>
			<option value="3">계약현황(차량정보|고객정보|대여정보)</option>
		</select>
		&nbsp;&nbsp;<a href="javascript:popup3()"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		
		&nbsp;&nbsp;<a href="javascript:popup4()"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
	</td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>

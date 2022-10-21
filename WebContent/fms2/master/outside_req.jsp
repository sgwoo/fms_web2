<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.secondhand.*, acar.insur.*, acar.memo.*, acar.admin.*,acar.common.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function save(work_st)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('무엇을 작업합니까? 알 수 없습니다.'); return;}
		
		fm.work_st.value = work_st;
		fm.target = 'i_no';
		fm.action = 'autowork_a.jsp';
		fm.submit();
	}
	
	function popup(url)
	{
		var fm = document.form1;
				
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}	
	
	function popup2(url, s_var)
	{
		var fm = document.form1;
		fm.s_var.value = s_var;		
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//관리현황
	Vector deb1s = ad_db.getStatDebtList("stat_rent_month");
	int deb1_size = deb1s.size();	
	
	CodeBean[] banks = c_db.getDebtCptCdAll(); 
	int bank_size = banks.length;
	
	
	int cnt = 0;
%>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_var' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

	<tr>
   	<td colspan=10>
    	      <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>외부요청자료</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
  	</td>
  </tr>
  <tr><td class=h></td></tr>
  <tr><td>&nbsp;</td></tr>
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;금융사 : 
                  <select name="bank_cd">			  
                        <%if(bank_size > 0){
        					for(int i = 0 ; i < bank_size ; i++){
        						CodeBean bank = banks[i];%>
                        <option value='<%= bank.getCode()%>'><%= bank.getNm()%></option>
                        <%	}
        				}	%>
                      </select>	  

	  </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
    

  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. 산은캐피탈  - <b>고객분석</b>
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_01.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		    &nbsp;&nbsp;(연번 | 상호 | 고객구분	| 업태 | 종목 | 대여대수 | 총대여료 | 잔여대여료 | 월대여료)
	  </td>
  </tr>
  <tr><td class=h></td></tr>
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. 산은캐피탈  - <b>대여료수금스케줄</b>
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_02.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		    &nbsp;&nbsp;(년월 | 건수 | 받을어음)
	  </td>
  </tr>
  <tr><td class=h></td></tr>
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. 산은캐피탈  - <b>대여료연체리스트</b>
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_03.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		    &nbsp;&nbsp;(연번 | 상호 | 차명 | 차량번호 | 연체개월 | 연체금액 | 비고)
	  </td>
  </tr>
  <tr><td class=h></td></tr>
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. 선택 금융사별 - <b>대여료연체리스트</b>
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_03_2.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		    &nbsp;&nbsp;(연번 | 상호 | 차명 | 차량번호 | 연체개월 | 연체금액 | 비고)
	  </td>
  </tr>
  <tr><td class=h></td></tr>  
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. 두산캐피탈  - <b>중요계약사항변경리스트</b> : 조회기준일 입력 <input type='text' size='11' name='end_dt' maxlength='10' class='default' value='<%=AddUtil.getDate(1)+"-"+AddUtil.getDate(2)+"-"+AddUtil.getMonthDate(AddUtil.getDate2(1),AddUtil.getDate2(2))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>		
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_04.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a><br>
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(연번 | 차량번호 | 차종	| 변경전-계약자 | 변경전-계약일자 | 변경후-계약자 | 변경후-계약일자 | 변경사유 | 대출일자)
	  </td>
  </tr>
  <tr><td class=h></td></tr>

  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. 메리츠캐피탈 - <b>고객구성,유종별비중,제조사별,차량종류별,계약기간별,년식별보유현황 </b> : 월마감
		  <select name="end_dt_09">
			  <%if(deb1_size > 0){
				    for(int i = 0 ; i < deb1_size ; i++){
							StatDebtBean sd = (StatDebtBean)deb1s.elementAt(i);%>		
			  <option value="<%=sd.getSave_dt()%>"><%=sd.getReg_dt()%></option>		
			  <%	}
					}%>
		  </select>
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_09.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	  </td>
  </tr>  
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;반영일자 : 20180829</td></tr>
  
  <tr><td class=h></td></tr>
  <tr><td><hr></td></tr>
  <tr><td class=h></td></tr>
    
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. <b>대여료연체현황 </b> : 실시간조회
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_05.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a><br>
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(연번 | 계약자 | 차량번호 | 연체금액 | 미도래총금액(연체분제외))
	  </td>
  </tr>
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;요청일자 : 20110517</td></tr>
  <tr><td class=h></td></tr>
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. <b>대여만기예정현황 (진행) </b> : 조회기준일 입력 <input type='text' size='11' name='end_dt_06' maxlength='10' class='default' value='<%=(AddUtil.getDate2(1)-1)+"-12-31"%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
	       &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_06.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a><br>
		   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(연번 | 년월 | 건수)
	  </td>
  </tr>  
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;요청일자 : 20110517</td></tr>
  <tr><td class=h></td></tr>
    
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. <b>대여만기예정현황 (예정) </b> : 조회기준일 입력 <input type='text' size='11' name='end_dt_07' maxlength='10' class='default' value='<%=(AddUtil.getDate2(1)-1)+"-12-31"%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
	       &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_07.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a><br>
		   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(연번 | 년월 | 건수)
	  </td>
  </tr>  
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;요청일자 : 20110517</td></tr>
  <tr><td class=h></td></tr>
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. <b>차량구매현황 </b> : 조회기준일 입력 <input type='text' size='11' name='end_dt_08' maxlength='10' class='default' value='<%=(AddUtil.getDate2(1)-1)+"-12-31"%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
	       &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_08.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a><br>
		   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(연번 | 년도 | 구분 | 대수 | 할부대수 | 현금대수 | 구매금액 | 취득세 | 등록비용 )
	  </td>
  </tr>  
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;요청일자 : 20130116</td></tr>
  <tr><td class=h></td></tr>

  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. 검색금융사  - <b>계약분석</b>
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_11.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		    &nbsp;&nbsp;(연번 | 차대번호 | 차량번호 | 차명 | 상호 | 고객구분	| 업태 | 종목 | 대여개월 | 대여개시일 | 대여만료일 | 총대여료 | 잔여대여료 | 월대여료 | 대출실행일 | 대출상태 )
	  </td>
  </tr>
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;요청일자 : 20200521</td></tr>
  <tr><td class=h></td></tr>  
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. <b> 매출추이 매출구성 </b> - 계약번호 연동 계산서 발행현황  : 조회기준일 입력 <input type='text' size='11' name='end_dt_12' maxlength='10' class='default' value='<%=(AddUtil.getDate2(1)-1)+"-01-01"%>' onBlur='javscript:this.value = ChangeDate(this.value);'>부터
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_12.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		    &nbsp;&nbsp;(구분 | 발행월 | 합계 | 전기차 | 1년이상 | 1년미만 )
	  </td>
  </tr>
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;요청일자 : 20210408</td></tr>
  <tr><td class=h></td></tr>    
  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>

<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=accid_s5_sc_excel.xls");
%>

<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"0":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"2":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	if(s_kd.equals("5")||s_kd.equals("9")||s_kd.equals("10")) t_wd = AddUtil.replace(t_wd, "-", "");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector accids = new Vector();
	
	if(gubun3.equals("4")){//미청구
		accids = as_db.getAccidS5List2(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
	}else{
		accids = as_db.getAccidS5List(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
	}
	
	int accid_size = accids.size();
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='accid_size' value='<%=accid_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1620'>
  <tr id='tr_title' style='position:relative;z-index:1'>
	<td width='480' id='td_title' style='position:relative;'>			
      <table border="1" cellspacing="1" cellpadding="0" width='480'>
        <tr>					
            <td class=title width='60'>연번</td>
            <td class=title width='60'>입금구분</td>
            <td class=title width='60'>사고유형</td>
		    <td class=title width='100'>계약번호</td>
		    <td class=title width='110'>상호</td>
		    <td class=title width='90'>차량번호</td>
		</tr>
	  </table>
	</td>
	<td width='1140'>
	    <table border="1" cellspacing="1" cellpadding="0" width='1140'>
          <tr> 
            <td class=title width='120'>사고일시</td>
            <td class=title width='60'>당사과실</td>			
            <td class=title width='100'>상대보험사</td>
            <td class=title width='80'>보험담당자</td>			
            <td class=title width='70'>청구구분</td>
            <td class=title width='150'>사용기간</td>
            <td class=title width='80'>청구일자</td>			
            <td class=title width='80'>청구금액</td>
            <td class=title width='80'>입금금액</td>						
            <td class=title width='80'>입금일자</td>			
            <td class=title width='80'>차액</td>									
            <td class=title width='100'>사유</td>
            <td class=title width='60'>관리담당</td>			
          </tr>
        </table>
	</td>
  </tr>
<%	if(accid_size > 0){%>
  <tr>
	<td width='480' id='td_con' style='position:relative;'>			
        <table border="1" cellspacing="1" cellpadding="0" width='480'>
          <% 		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);%>
          <tr> 
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'><a name="<%=i+1%>"><%=i+1%> 
              <%if(accid.get("USE_YN").equals("Y")){%>
              <%}else{%>
              (해약) 
              <%}%>
              </a></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'> 
              <%if(String.valueOf(accid.get("PAY_DT")).equals("")){%>
              <font color="#FF6600">미수금</font>
              <%}else{%>
              수금 
              <%}%>
            </td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'><%=accid.get("ACCID_ST_NM")%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><%=accid.get("RENT_L_CD")%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='110' align='center'><%=accid.get("FIRM_NM")%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='90' align='center'><%=accid.get("CAR_NO")%></td>
          </tr>
          <%		}%>
          <tr> 
            <td class=title colspan="6" align='center'>&nbsp;</td>
          </tr>
        </table>
	</td>
	<td width='1140'>
	    <table border="1" cellspacing="1" cellpadding="0" width='1140'>
          <%		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);%>
          <tr> 
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='120' align='center'><%=AddUtil.ChangeDate3(String.valueOf(accid.get("ACCID_DT")))%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'><%=accid.get("OUR_FAULT_PER")%>%</td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><%=accid.get("INS_COM")%></td>			
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='center'><span title='<%=accid.get("INS_NM")%>'><%=Util.subData(String.valueOf(accid.get("INS_NM")), 4)%></span>
            </td>			
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='70' align='center'><%=accid.get("REQ_GU")%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='150' align='center'><%=AddUtil.ChangeDate2(String.valueOf(accid.get("USE_ST")))%>~<%=AddUtil.ChangeDate2(String.valueOf(accid.get("USE_ET")))%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='center'>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(accid.get("REQ_DT")))%></td>			
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(accid.get("REQ_AMT")))%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(accid.get("PAY_AMT")))%></td>			
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='center'>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(accid.get("PAY_DT")))%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(accid.get("DEF_AMT")))%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><%=accid.get("RE_REASON")%></td>	       
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'><%=c_db.getNameById(String.valueOf(accid.get("BUS_ID2")),"USER")%></td>
          </tr>
          <%		total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(accid.get("REQ_AMT")));
		 			total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(accid.get("PAY_AMT")));
					total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(accid.get("DEF_AMT")));
		  			}%>
          <tr> 
            <td class=title align='center'>&nbsp;</td>
            <td class=title align='center'>&nbsp;</td>			
            <td class=title align='center'>&nbsp;</td>			
            <td class=title align='center'>&nbsp;</td>
            <td class=title align='center'>&nbsp;</td>			
            <td class=title align='center'>&nbsp;</td>
            <td class=title align='center'>계</td>
            <td class=title width='80' align='right'><%=Util.parseDecimal(total_amt1)%>원</td>
            <td class=title width='80' align='right'><%=Util.parseDecimal(total_amt2)%>원</td>			
            <td class=title width='80' align='center'>&nbsp;</td>
            <td class=title width='80' align='right'><%=Util.parseDecimal(total_amt3)%>원</td>						
            <td class=title align='center'>&nbsp;</td>			
            <td class=title align='center'>&nbsp;</td>						
          </tr>
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	<td width='480' id='td_con' style='position:relative;'>			
      <table border="1" cellspacing="1" cellpadding="0" width='480'>
        <tr>
		  <td align='center'>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
	<td width='1140'>
	    <table border="1" cellspacing="1" cellpadding="0" width='1140'>
          <tr>
		  <td>&nbsp;</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
</table>
<script language='javascript'>
<!--
/*	var fm 		= document.form1;
	var p_fm	= parent.form1;
	var cnt 	= fm.fee_size.value;
	
	var i_amt = 0;
	
	if(cnt > 1){
		for(var i = 0 ; i < cnt ; i++){
			i_amt   += toInt(parseDigit(fm.amt[i].value));
		}
	}else if(cnt == 1){
		i_amt   += toInt(parseDigit(fm.amt.value));	
	}		*/
//-->
</script>
</form>
</body>
</html>

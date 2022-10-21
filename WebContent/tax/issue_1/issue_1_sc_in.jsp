<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	if(!st_dt.equals("") && end_dt.equals("")) end_dt = st_dt;
	
	Vector vts = IssueDb.getIssue1List(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size = vts.size();
%>

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
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
<input type='hidden' name='reg_st' value=''>
<input type='hidden' name='reg_gu' value=''>
<input type='hidden' name='ebill_yn' value=''>
<input type='hidden' name='cng_st' value=''>
<input type='hidden' name='tax_out_dt' value=''>
<input type='hidden' name='tax_out_dt2' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
  <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>
	  <td class='line' width='45%' id='td_title' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	    	
          <tr> 
            <td width='10%' class='title'>연번</td>
            <td width='10%' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
            <td width='30%' class='title'>상호</td>			
            <td width='20%' class='title'>차량번호</td>			
            <td width='20%' class='title'>차명</td>			
            <td width='10%' class='title'>회차</td>
          </tr>
        </table></td>
	<td class='line' width='55%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td width='14%' class='title'>공급가</td>
            <td width='13%' class='title'>부가세</td>
            <td width='14%' class='title'>합계</td>			
            <td width='14%' class='title'>입금예정일</td>
            <td width='14%' class='title'>세금일자</td>
            <td width='14%' class='title'>발행예정일</td>			
            <td width='12%' class='title'>상태</td>						
          </tr>
        </table>
	</td>
  </tr>
<%	if(vt_size > 0){%>
  <tr>
	  <td class='line' width='45%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);
				String client_cont = "-";
				if(!String.valueOf(ht.get("CNT1")).equals("")) client_cont += "<font color=red>장</font>-";
				if(!String.valueOf(ht.get("CNT2")).equals("")) client_cont += "<font color=red>셀</font>-";
				if(!String.valueOf(ht.get("CNT3")).equals("")) client_cont += "<font color=red>기</font>-";%>
          <tr> 
            <td width='10%' align='center'><a name="<%=i+1%>"><%=i+1%></a></td>
            <td width='10%' align='center'>
			<input type="checkbox" name="ch_l_cd" value="<%=ht.get("RENT_MNG_ID")%><%=ht.get("RENT_L_CD")%><%=ht.get("RENT_ST")%><%=ht.get("RENT_SEQ")%><%=ht.get("FEE_TM")%>">
			<input type='hidden'   name="h_l_cd"  value="<%=ht.get("RENT_MNG_ID")%><%=ht.get("RENT_L_CD")%><%=ht.get("RENT_ST")%><%=ht.get("RENT_SEQ")%><%=ht.get("FEE_TM")%>">
			</td>
            <td width='30%' align='center'><span title='<%=ht.get("FIRM_NM")%> (<%=ht.get("CLIENT_ID")%>, <%=ht.get("RENT_L_CD")%>, <%=ht.get("CLS_ST")%>)'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 10)%></span></td>			
            <td width='20%' align='center'><%=ht.get("CAR_NO")%></td>
            <td width='20%' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 4)%></span></td>
            <td width='10%' align='center'><%=ht.get("FEE_TM")%>회</td>
          </tr>
          <%}%>
        </table></td>
	<td class='line' width='55%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td width='14%' align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>원&nbsp;</td>
            <td width='13%' align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("FEE_V_AMT")))%>원&nbsp;</td>
            <td width='14%' align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원&nbsp;</td>
            <td width='14%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_FEE_EST_DT")))%></td>
            <td width='14%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>			
            <td width='14%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_REQ_DT")))%></td>		
            <td width='12%' align='center'><%=ht.get("USE_YN")%><%//=ht.get("CLS_ST")%></td>							
          </tr>
          <%}%>
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='45%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>등록된 데이타가 없습니다</td>
          </tr>
        </table></td>
	<td class='line' width='55%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>&nbsp;</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
</table>
</form>
</body>
</html>

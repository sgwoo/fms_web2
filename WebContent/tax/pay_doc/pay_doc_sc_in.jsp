<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
//  사업자번호,주민번호는 '-' 뺀다
	if(s_kd.equals("4")) t_wd = AddUtil.replace(t_wd, "-", "");

	Vector vts = ScdMngDb.getPayMngList(s_br, chk1, chk2, chk3, chk4, chk5, chk6, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
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
//메시지 입력시 string() 길이 체크
function checklen()
{
	var msgtext, msglen;
	
	msgtext = document.form1.msg.value;
	msglen = document.form1.msglen.value;
	
	var i=0,l=0;
	var temp,lastl;
	
	//길이를 구한다.
	while(i < msgtext.length)
	{
		temp = msgtext.charAt(i);
		
		if (escape(temp).length > 4)
			l+=2;
		else if (temp!='\r')
			l++;
		// OverFlow
		if(l>37)
		{
			alert("메시지란에 허용 길이 이상의 글을 쓰셨습니다.\n 메시지란에는 한글 18자, 영문37자까지만 쓰실 수 있습니다.");
			temp = document.form1.msg.value.substr(0,i);
			document.form1.msg.value = temp;
			l = lastl;
			break;
		}
		lastl = l;
		i++;
	}
	form1.msglen.value=l;
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
  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
  	<tr><td class=line2 colspan="2"></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='40%' id='td_title' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
          <td width='10%' class='title'>연번</td>
          <td width='45%' class='title'>상호</td>
          <td width='25%' class='title'>사업자번호</td>
          <td width='20%' class='title'>발행일자</td>		  
          </tr>
        </table>
      </td>
	    <td class='line' width='60%'>
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td width='15%' class='title'>공급가</td>
            <td width='15%' class='title'>부가세</td>
            <td width='40%' class='title'>비고</td>			
            <td width='15%' class='title'>전자입금표</td>
            <td width='15%' class='title'>상태</td>
          </tr>
        </table>
	    </td>
    </tr>
<%	if(vt_size > 0){%>
    <tr>
	    <td class='line' width='40%' id='td_con' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td <%if(String.valueOf(ht.get("DOCATTR")).equals("D"))out.println("class='is'");%> width='10%' align='center'><a name="<%=i+1%>"><%=i+1%></a></td>
            <td <%if(String.valueOf(ht.get("DOCATTR")).equals("D"))out.println("class='is'");%> width='45%' align='center'><span title='<%=ht.get("RECCONAME")%>'><%=AddUtil.subData(String.valueOf(ht.get("RECCONAME")), 12)%></span><a href="javascript:parent.view_tax('<%=ht.get("SEQID")%>','<%=i+1%>')" onMouseOver="window.status=''; return true"></a></td>			
            <td <%if(String.valueOf(ht.get("DOCATTR")).equals("D"))out.println("class='is'");%> width='25%' align='center'><%=AddUtil.ChangeEnpH(String.valueOf(ht.get("RECCOREGNO")))%></td>
            <td <%if(String.valueOf(ht.get("DOCATTR")).equals("D"))out.println("class='is'");%> width='20%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUBDATE")))%></td>				  
          </tr>
          <%}%>
        </table>
	    </td>
	    <td class='line' width='60%'>
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td <%if(String.valueOf(ht.get("DOCATTR")).equals("D"))out.println("class='is'");%> width='15%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("SUPPRICE")))%>원&nbsp;</td>
            <td <%if(String.valueOf(ht.get("DOCATTR")).equals("D"))out.println("class='is'");%> width='15%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX")))%>원&nbsp;</td>
            <td <%if(String.valueOf(ht.get("DOCATTR")).equals("D"))out.println("class='is'");%> width='40%' align="center"><span title='<%=ht.get("REMARKS")%>'><%=AddUtil.subData(String.valueOf(ht.get("REMARKS")), 25)%></span></td>
            <td <%if(String.valueOf(ht.get("DOCATTR")).equals("D"))out.println("class='is'");%> width='15%' align="center">
			  <%	if(String.valueOf(ht.get("PUBCODE")).equals("")){%>
			  -
			  <%	}else{%>
			  <a href="javascript:parent.viewDepoSlip('<%=ht.get("PUBCODE")%>')"><%=ht.get("STATUS")%></a>
			  <%	}%>		
			</td>							
            <td <%if(String.valueOf(ht.get("DOCATTR")).equals("D"))out.println("class='is'");%> width='15%' align="center">
			      <%if(String.valueOf(ht.get("DOCATTR")).equals("D")){%>
			      <font color=red>발행취소</font>
			      <%}else if(String.valueOf(ht.get("DOCATTR")).equals("U")){%>
			      변경
			      <%}else{%>
		          정상
			      <%}%>			            
            </td>		
          </tr>
          <%}%>
        </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='40%' id='td_con' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>등록된 데이타가 없습니다</td>
          </tr>
        </table>
      </td>
	    <td class='line' width='60%'>
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
<script language="JavaScript">
<!--
//-->
</script>
</body>
</html>

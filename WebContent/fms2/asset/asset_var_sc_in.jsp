<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*" %>
<jsp:useBean id="bean" class="acar.asset.AssetVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	
	
	AssetDatabase a_db = AssetDatabase.getInstance();
	
	bean = a_db.getAssetVarList(gubun1);
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function update(){
		var fm = document.form1;
		fm.target='d_content';
		fm.submit();
	}
		
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
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onLoad="javascript:init()">
<form name="form1" method="post" action="asset_var_i.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="a_a" value="<%=bean.getA_a()%>">          
  <input type="hidden" name="seq" value="<%=bean.getSeq()%>">   
  <input type="hidden" name="cmd" value="">
  
  <table border=0 cellspacing=0 cellpadding=0 width=800>
  <tr> 
    <td>1. <a href="javascript:update()">자산변수</a></td>
  
  </tr>
  
  <tr> 
    <td colspan="2" class=line> <table border=0 cellspacing=1 width=800>
        <tr> 
          <td class=title width="95">변수기호</td>
          <td class=title width="99">변수코드</td>
          <td class=title colspan="2">변수명</td>
          <td class=title width="97">변수값</td>
        </tr>
        <tr> 
          <td align="center" width="95" >A</td>
          <td align="center" >a_1</td>
          <td colspan="2">자산계정코드</td>
          <td align="right"><%=bean.getA_1()%>&nbsp;&nbsp;</td>
          
        </tr>
        <tr> 
          <td align="center" width="95" rowspan="3" >B</td>
          <td align="center" >b_1</td>
          <td colspan="2">내용연수</td>
          <td align="right"><%= bean.getB_1()%>
          &nbsp;</td>
        </tr>
        <tr> 
          <td align="center">b_2</td>
          <td colspan="2">적용구분</td>
          <td align="right">
<%          if (bean.getB_2().equals("1")){%>취득일자 <%}%>          
      	  &nbsp;</td>
        </tr>
        <tr> 
          <td align="center">b_3</td>
          <td colspan="2">적용기준일</td>
          <td align="right"><%=AddUtil.ChangeDate2(bean.getB_3())%>&nbsp;&nbsp;</td>
        </tr>
        <tr> 
          <td align="center" width="95" rowspan="3" >C</td>
          <td align="center" >c_1</td>
          <td colspan="2">상각방법</td>
          <td align="right">
<%          if (bean.getC_1().equals("1")){%>정액법 <%}else if( bean.getC_1().equals("2")){%>정율법 <%}%>          
 		  &nbsp;</td>
        </tr>
        <tr> 
          <td align="center">c_2</td>
          <td colspan="2">상각율</td>
          <td align="right"><%=bean.getC_2()%>&nbsp;&nbsp;</td>
        </tr>
        <tr> 
          <td align="center">c_3</td>
          <td colspan="2">적용기준일</td>
          <td align="right"><%=AddUtil.ChangeDate2(bean.getC_3())%>&nbsp;&nbsp;</td>
        </tr>
        <tr> 
          <td align="center" width="95" rowspan="3" >D</td>
          <td align="center" >d_1</td>
          <td colspan="2">상각비계정</td>
          <td align="right">
<%          if (bean.getD_1().equals("1")){%>감가상각(리스) <%}else if( bean.getD_1().equals("2")){%>감가상각(대여) <%}%>          
 		  &nbsp;</td>
        </tr>
        <tr> 
          <td align="center">d_2</td>
          <td colspan="2">상각비계정코드</td>
          <td align="right"><%=bean.getD_2()%>&nbsp;&nbsp;</td>
        </tr>
        <tr> 
          <td align="center">d_3</td>
          <td colspan="2">적용기준일</td>
          <td align="right"><%=AddUtil.ChangeDate2(bean.getD_3())%>&nbsp;&nbsp;</td>
        </tr>
     </table></td>
   </tr>     

  </table>
</form>
</body>
</html>

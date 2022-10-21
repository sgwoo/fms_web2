<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String car_no	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String from_req_dt 	= request.getParameter("from_req_dt")==null?"":request.getParameter("from_req_dt");
	
	
	
	
	Vector vt = cs_db.getConsignmentCarList(car_no, from_req_dt);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_cons(cons_no, seq){
		var width 	= 800;
		var height 	= 700;		
		window.open("cons_reg_print.jsp?cons_no="+cons_no+"&seq="+seq+"&step=3", "Print", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
      <td>&lt; 탁송 의뢰 리스트 &gt; </td>
    </tr>  
    <tr>
      <td>&nbsp;</td>
    </tr>  
    <tr>
      <td class=line><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="10%" class=title>차량번호</td>		  
          <td width="40%" align='center'><%=car_no%></td>
          <td width="10%" class=title>출발요청일자</td>
          <td width="40%" align='center'><%=from_req_dt%></td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>  
	<tr>
	  <td class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr valign="middle" align="center"> 
		    <td width='30' rowspan="2" class=title>연번</td>
		    <td width='80' rowspan="2" class=title>탁송사유</td>
		    <td width='90' rowspan="2" class=title >차량번호</td>
		    <td width='100' rowspan="2" class=title>차명</td>
		    <td colspan="2" class=title>출발</td>
		    <td colspan="2" class=title>도착</td>
		    <td width="60" rowspan="2" class=title>운전자</td>
		    <td width="60" rowspan="2" class=title>의뢰자</td>
	      </tr>
		  <tr valign="middle" align="center">
		    <td width='110' class=title>지점</td>		  
		    <td width='130' class=title>시간</td>		  
		    <td width='110' class=title>지점</td>		  
		    <td width='130' class=title>시간</td>		  
		  </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		  <tr> 
		    <td align='center'><%=i+1%></td>
		    <td align='center'><%=ht.get("CONS_CAU_NM")%></td>
		    <td align='center'><%=ht.get("CAR_NO")%></td>
		    <td align='center'><%=ht.get("CAR_NM")%></td>			
		    <td align='center'><span title='<%=ht.get("FROM_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("FROM_PLACE")), 6)%></span></td>
		    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("FROM_DT")))%></td>			
		    <td align='center'><span title='<%=ht.get("TO_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("TO_PLACE")), 6)%></span></td>
		    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("TO_DT")))%></td>			
		    <td align='center'><%=ht.get("DRIVER_NM")%></td>			
		    <td align='center'><%=ht.get("USER_NM1")%></td>
		  </tr>
  <%	 }%>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td align="right"><a href="javascript:window.close();" onMouseOver="window.status=''; return true">닫기</a>
	  </td>
	</tr>
  </table>
</form>  
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

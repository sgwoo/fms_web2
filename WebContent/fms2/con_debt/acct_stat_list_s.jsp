<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	String first 	= request.getParameter("first")==null?"":request.getParameter("first");
   
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");		
	
	int i_height =AddUtil.parseInt(height) - 50;
		
	Vector vt = new Vector();
	
	if ( !first.equals("Y")) vt = ad_db.getSettleAccount_list4_2016(gubun1, "client", "Y", gubun2);  //네오엠과 차액 표시
	
	int vt_size = vt.size(); 
		
	long total_amt1	= 0;
	long total_amt2	= 0;
	long total_amt3	= 0;
	long total_amt4	= 0;
	long total_amt5	= 0;
%>


<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">
</head>

<body>
<form name='form1'  id="form1" action='' method='post' >
  <input type='hidden' name='height' id="height" value='<%=i_height%>'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' value='<%=gubun2%>'>
 
  <table border="0" cellspacing="1" cellpadding="0" width=90%>
	<tr>
	  <td align="center"><%=AddUtil.parseInt(gubun1)%>년 계약보증금리스트
	  <% if ( gubun2.equals("1") ) { %>(네오엠기준)<% } else {%>(FMS기준)<% } %></td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
    </tr>		
	
 </table>
 	
 <div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>				
				<td style="width: 100%;">
					<div style="width: 100%;">
						<table class="inner_top_table table_layout" style="height: 60px;">
							<tr>						
						        <td width="50" class='title title_border' style='height:45'>연번</td>			                 
								<td width="320" class="title title_border">거래처명</td>
								<td width="120" class="title title_border">사업자번호</td>
								<td width="120" class="title title_border">보증금액</td>
								<td width="120" class="title title_border">입금액</td>
								<td width="120" class="title title_border">차액</td>
								<td width="120" class="title title_border">네오엠</td>
								<td width="120" class="title title_border">네오엠 차액</td>
								<td width="120" class="title title_border">네오엠코드</td>
				  
			                </tr>
			     		</table>
			        </div>
			    </td>  
			</tr>    		     
    	</table>
	</div>
	
	<div class="tb_box">
		<table class="tb">
			<tr>
			   <td style="width: 100%;">	
		     	 <div style="width: 100%;">	
					<table class="inner_top_table table_layout">   	   
					           
		          <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);					
					total_amt1	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT")));					
					total_amt2	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT")));
					total_amt3	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
					total_amt4	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("ACCT_AMT")));
			  	  %>
				
		                <tr style='height:30' > 
		                  <td width='50' class="center content_border"><%=i+1%></td>
				 		  <td width='320' class="center content_border"><%=ht.get("FIRM_NM")%></td>
						  <td width='120' class="center content_border"><%=AddUtil.ChangeEnp(String.valueOf(ht.get("ENP_NO")))%></td>
						  <td width='120' class="right content_border"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT"))))%></td>
						  <td width='120' class="right content_border"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT"))))%></td>
						  <td width='120' class="right content_border"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT"))))%></td>
						  <td width='120' class="right content_border"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("ACCT_AMT"))))%></td>
						  <td width='120' class="right content_border"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("CAL_AMT"))))%></td>
						  <td width='120' class="center content_border"><%=ht.get("ACCT_CODE")%></td>		                 
		                </tr>
		          <%		}%>
		                <tr style='height:30' > 
	                      <td width='50' class="title center content_border">&nbsp;</td>
						  <td width='320' class="title center content_border">&nbsp;</td>
						  <td width='120' class="title center content_border">&nbsp;</td>
						  <td width='120' class="title right content_border" ><%=Util.parseDecimal(total_amt1)%></td>
						  <td width='120' class="title right content_border" ><%=Util.parseDecimal(total_amt2)%></td>
						  <td width='120' class="title right content_border" ><%=Util.parseDecimal(total_amt3)%></td>
						  <td width='120' class="title right content_border" ><%=Util.parseDecimal(total_amt4)%></td>
						  <td width='120' class="title center content_border" ></td>
						  <td width='120' class="title center content_border">&nbsp;</td>		                 
		                </tr>
		            </table>
         	 	</div>  
        	</td>
   		 </tr>
   	 </table>
	</div>
</div>  

</form>
 	 	
<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>

<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;
		
	
 	}
//-->
</script> 	 	 	 	  	
</body>
</html>

	
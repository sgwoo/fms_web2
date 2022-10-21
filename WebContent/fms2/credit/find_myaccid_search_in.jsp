<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.settle_acc.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	
	String auth_rw = "";
	
	String g_fm = "1";
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String r_gov_id = request.getParameter("r_gov_id")==null?"":request.getParameter("r_gov_id");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	
	String t_wd = request.getParameter("t_wd")==null?"2":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String st_dt = request.getParameter("st_dt")==null?Util.getDate():request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?Util.getDate():request.getParameter("end_dt");
		
	//보험접수번호 없는건 안나오게 - 소송못함
	Vector settles = s_db.getInsurHList("", "", st_dt, end_dt, "1", t_wd);
	int settle_size = settles.size();
	
	long total_amt1 	= 0;
	long total_amt2 	= 0;
	long total_amt3 	= 0;
	long total_amt4 	= 0;
	long total_amt5 	= 0;	
			
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "cho_id"){		
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
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='r_gov_id' value='<%=r_gov_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            	  <tr> 
            	    <td class='title' width=4%> 연번</td>
		            <td class='title' width="4%"><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		            <td class='title' width="10%">차량번호</td>
		            <td class='title' width="10%">보험사</td>
		            <td class='title' width="10%">사고구분</td>
		            <td class='title' width="9%">사고일자</td>			
		            <td class='title' width="9%">청구일자</td>						
		            <td class='title' width="9%">청구액</td>									
		            <td class='title' width="9%">입금일자</td>												
		            <td class='title' width="9%">입금액</td>
		            <td class='title' width="9%">차액</td>
		            <td class='title' width="8%">연체이자</td>
		          </tr>
          
                </tr>
        <%	for (int i = 0 ; i < settle_size ; i++){
				Hashtable settle = (Hashtable)settles.elementAt(i);
				total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(settle.get("REQ_AMT")));
				total_amt2 	= total_amt2 + Long.parseLong(String.valueOf(settle.get("PAY_AMT")));
				total_amt3 	= total_amt3 + Long.parseLong(String.valueOf(settle.get("DEF_AMT")));
				total_amt4 	= total_amt4 + Long.parseLong(String.valueOf(settle.get("DLY_AMT")));
				%>
		  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td> 
                      <input type="checkbox" name="cho_id" value="<%=settle.get("ACCID_ID")%>^<%=settle.get("SEQ_NO")%>^<%=settle.get("CAR_MNG_ID")%>^<%=r_gov_id%>^">
                    </td>
                    <td align='center'><%=settle.get("CAR_NO")%></td>
			        <td align='center' ><%=settle.get("INS_COM")%></td>
			        <td align='center' ><%=settle.get("ACCID_ST")%></td>
			        <td align='center' ><%=settle.get("ACCID_DT")%></td>			
			        <td align='center' ><%=settle.get("REQ_DT")%></td>						
			        <td align='right' ><%=Util.parseDecimal(String.valueOf(settle.get("REQ_AMT")))%></td>									
			        <td align='center' ><%=settle.get("PAY_DT")%></td>												
			        <td align='right' ><%=Util.parseDecimal(String.valueOf(settle.get("PAY_AMT")))%></td>
			        <td align='right' ><%=Util.parseDecimal(String.valueOf(settle.get("DEF_AMT")))%></td>
			        <td align='right' ><%=Util.parseDecimal(String.valueOf(settle.get("DLY_AMT")))%></td>
			   
                </tr>
          <%		}%>
          <tr> 
                    <td class="title" colspan="7">합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
                    <td class="title">&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>			
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>

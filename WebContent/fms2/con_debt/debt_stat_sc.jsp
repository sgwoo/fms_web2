<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");

	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");  //기수 
//	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	
	String first 	= request.getParameter("first")==null?"":request.getParameter("first");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
		
	long amt13 = 0;
	long amt15 = 0;
	long grt_amt = 0;
	
	//System.out.println("first="+first);

	if ( first.equals("Y")) return; 
			   	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
 	//계약서 내용 보기
//	function view_asset(asset_ym, gubun1){
//			window.open('view_assetdep_list.jsp?asset_ym='+asset_ym+'&gubun1='+gubun1, "ASSETDEP_LIST", "left=30, top=30, width=950, height=700, resizable=yes, scrollbars=yes, status=yes");
//	}
	
	
function search_excel(s_i){
	var fm = document.form1;
	fm.mm.value = s_i;
	fm.action = 'debt_stat_sc_excel.jsp';				
	fm.target = '_blank';
	fm.submit()		
}

//-->
</script>
</head>

<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
   <input type='hidden' name='mm' 	>  
 
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
    
<table border="0" cellspacing="0" cellpadding="0" width=70%>
    <tr><td class=line2></td></tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width='99%'>			  
                <tr>
                    <td width='16%' class='title'>년월</td>
                    <td class='title' width="14%">유동성 장기차입금</td>
                    <td class='title' width="14%">유동성 장기대여보증금</td>
              
                </tr>
          <%	for(int i = 1 ; i <= 12 ; i++){
        	    String s_i = Integer.toString(i);
        	         	  
        		if(s_i.length() == 1) s_i = "0"+s_i;
        		      		
        		
        		//유동성 차입금
        	    Vector vt = ad_db.getDebtSettleList1(gubun1, s_i); 
        	    
        	    for(int ii = 0 ; ii < vt.size(); ii++){
        			Hashtable debt = (Hashtable)vt.elementAt(ii);        			
        			
        			amt13 = AddUtil.parseLong(String.valueOf(debt.get("AMT13"))); 
        			amt15 = AddUtil.parseLong(String.valueOf(debt.get("AMT15")));         			
        	    } 
        	    
        		//유동성 보증금 
        	    Vector vt1 = ad_db.getSettleAccount_list14(gubun1, s_i); 
        	    
        	    for(int ii = 0 ; ii < vt1.size(); ii++){
        			Hashtable debt1 = (Hashtable)vt1.elementAt(ii);        			
        			
        			grt_amt = AddUtil.parseLong(String.valueOf(debt1.get("GRT_AMT")));         			    			
        	    } 
        	    %>		  
                <tr> 
                    <td align="center"><%=i%>월</td>
                  
                    <td align="right"><a href="javascript:search_excel('<%=s_i%>')"><%=AddUtil.parseDecimalLong(amt13+amt15)%></a></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(grt_amt)%></td>                  
                </tr>
<%			
	
}%>			  
            
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
</table>
</form>
</body>
</html>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.asset.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String asset_code = request.getParameter("asset_code")==null?"":request.getParameter("asset_code");
	
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	AssetDatabase a_db = AssetDatabase.getInstance();
	
	Vector vt = new Vector();
	vt = a_db.getAssetDepList(asset_code);
	
	int cont_size = vt.size();
 	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr><td class=line2></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1' >		
        <td class='line' width='100%' id='td_title' style='position:relative;' > 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                  <td width='5%' class='title'>연번</td>
                  <td width='5%' class='title'>기수</td>
                  <td width='10%' class='title'>기초가액</td>
                  <td width='10%' class='title'>증가</td>
                  <td width='10%' class='title'>감소</td>
                  <td width='10%' class='title'>기말잔액</td>
                  <td width='10%' class='title'>당기상각비</td>
                  <td width='10%' class='title'>구매보조금</td>
                  <td width='10%' class='title'>당기말충당금</td>
                  <td width='10%' class='title'>당기말구매보조금</td>
                  <td width="10%" class='title'>당기말장부가액</td>
                </tr>
            </table>
	    </td>	
    </tr>
    <%if(cont_size > 0){%>
    <tr>		
        <td class='line' width='100%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(!String.valueOf(ht.get("DEPRF_YN")).equals("3")) td_color = "class='is'";
	
				long t1=0;
				long t2=0;
				long t3=0;
				long t4=0;   
				long t5=0;
				long t6=0;
				long t7=0;
			    long t8=0;
			    long t9=0;  //구매보조금 
			   long t10=0;  //당기말 구매보조금 
												
			   t1 = AddUtil.parseLong(String.valueOf(ht.get("GET_AMT")));
             t2 = AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR")));
             t3 = AddUtil.parseLong(String.valueOf(ht.get("BOOK_CR")));
             t4 = t1 + t2 - t3; //기말잔액 
             	
			  	t5 = AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT"))); 
			  	t6 = AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")));
			  					
				t9 = AddUtil.parseLong(String.valueOf(ht.get("GDEP_MAMT")));  
				t10 = AddUtil.parseLong(String.valueOf(ht.get("GDEP_AMT")));   //당기말 구매보조금 잔액 
				
			  	t7 = t5 + t6   ;	  //상각누계
			 
			  				  	
			  	//상각완료, 매각
			  	if (t4 == 0) {
			  		t8 = 0;
			  	} else {
			  	  	t8 = t4 - t7 - t10;   //
 			    }
	
		%>
                <tr> 
                  <td <%=td_color%> width='5%' align='center'><%=i+1%></td>
                  <td <%=td_color%> width='5%' align='center'><!--<a href="javascript:parent.view_asset('<%=ht.get("ASSET_CODE")%>', '<%=ht.get("GISU")%>')" onMouseOver="window.status=''; return true">--><%=ht.get("GISU")%></a></td>
                  <td <%=td_color%> width='10%' align='right'><%=Util.parseDecimal(t1)%>&nbsp;</td>
                  <td <%=td_color%> width='10%' align='right'><%=Util.parseDecimal(t2)%>&nbsp;</td>	
                  <td <%=td_color%> width='10%' align='right'><%=Util.parseDecimal(t3)%>&nbsp;</td>
                  <td <%=td_color%> width='10%' align='right'><%=Util.parseDecimal(t4)%>&nbsp;</td>		
                  
                  <td <%=td_color%> width="10%" align='right'><%=Util.parseDecimal(t5)%>&nbsp;</td>
                  <td <%=td_color%> width="10%" align='right'><%=Util.parseDecimal(t9)%>&nbsp;</td>
                  
                  <td <%=td_color%> width="10%" align='right'><%=Util.parseDecimal(t7)%>&nbsp;</td>
                  <td <%=td_color%> width="10%" align='right'><%=Util.parseDecimal(t10)%>&nbsp;</td>
                  <td <%=td_color%> width="10%" align='right'><%=Util.parseDecimal(t8)%>&nbsp;</td>
                </tr>
                <%		}	%>
              
            </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='100%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'><%if(asset_code.equals("")){%>검색어를 입력하십시오.<%}else{%>등록된 데이타가 없습니다<%}%></td>
                </tr>
            </table>
	    </td>
	
	
    </tr>
<%	}	%>
</table>
</body>
</html>



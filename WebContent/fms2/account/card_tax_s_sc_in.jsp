<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ic_db" scope="page" class="acar.incom.IncomDatabase" />
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String gubun0 	= request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String height = request.getParameter("height")==null?"":request.getParameter("height");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	long gtotal_amt = 0;	
	long grtotal_amt = 0;	
	long gitotal_amt = 0;	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	Vector vt = ic_db.getCardPayList( gubun0,  gubun2, gubun3, st_mon);		
	int vt_size = vt.size();
	
	long total_amt =0;
	long tax_amt =0;
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style>
.scroll {
  
  overflow: auto;
}
</style>
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

<body rightmargin=0>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="4%" class='title'>연번</td>   
                	<td width="10%" class='title'>거래일자</td>   
                  	<td width='15%' class='title'>카드사</td>
                  	<td width="8%" class='title'>입금액</td>   
                 	<td width="12%" class='title'>사업자/주민번호</td>	
        		  	<td width="20%" class='title'>고객</td>	
        		  	<td width="23%" class='title'>내역</td>
        		  	<td width="8%" class='title'>과세매출액</td>   
                </tr>
 
    
  <%if(vt_size > 0){%>
   
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
		%>
             	<tr> 
                  <td width='4%' align='center'><%=i+1%></td>
                  <td width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%></td>
                  <td width='15%' align='center'><%=ht.get("CARD_NM")%></td> 
                  <td width='8%' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("INCOM_AMT")))%></td>
                  <td width='12%' align='center'><%=ht.get("REGNO")%></td>		        		
        		  <td width='20%' align='center'><%=ht.get("FIRM_NM")%></td>		
        		  <td width='23%' align='left'><span title='<%=ht.get("CARD_DOC_CONT")%>'><%=Util.subData(String.valueOf(ht.get("CARD_DOC_CONT")), 34)%></span></td>			
        		  <td width='8%' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("TAX_AMT")))%></td>       		 
                              
                </tr>              
                <%		
                total_amt  = total_amt  + Long.parseLong(String.valueOf(ht.get("INCOM_AMT")));    
            	tax_amt  = tax_amt  + Long.parseLong(String.valueOf(ht.get("TAX_AMT")));
        
       			 }	%>
                
                <tr>
                    <td class="title" align='center' colspan=3>합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
                    <td class="title" align='center' colspan=3></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(tax_amt)%></td>                  
        	    </tr>			
        	  
 <%	}else{%>                     
			    <tr>
				     <td colspan="8" align="center"> &nbsp;등록된 데이타가 없습니다.</td>
			    </tr>
<% 	}%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>


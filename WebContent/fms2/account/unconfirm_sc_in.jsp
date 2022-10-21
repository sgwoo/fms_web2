<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.incom.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt =  a_db.getIncomListChk("2", t_wd, dt, ref_dt1, ref_dt2);
	int incom_size = vt.size();
	
	String value[] = new String[2];	
	
	long total_amt = 0;
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
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}

//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
        <td class='line' width='40%' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='17%' class='title'>연번</td>
                    <td width='24%' class='title'>은행</td>
                    <td width='33%' class='title'>계좌번호</td>
                    <td width="26%" class='title'>거래일자</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='60%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
            	    <td width="12%" class='title'>처리내역</td>
            	    <td width="7%" class='title'>확인</td>
            	
            	    <td width="55%" class='title'>적요</td>
        	        <td width="15%" class='title'>입금액</td>
        		    	  	     
		        </tr>
	        </table>
	    </td>
    </tr>
    <%if(incom_size > 0){%>
    <tr>		
        <td class='line' width='40%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < incom_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				StringTokenizer st = new StringTokenizer(String.valueOf(ht.get("BANK_NM")),":");
				int s=0; 
				while(st.hasMoreTokens()){
						value[s] = st.nextToken();
						s++;
				}
		%>
                <tr> 
                    <td width='17%' align='center'><%=i+1%></td>
                    <td width='24%' align='center'><%=value[1]%></td>
                    <td width='33%' align='center'><%=ht.get("BANK_NO")%></td>
                    <td width='26%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%></td>
                </tr>
      
        <%		}	%>
                <tr>
                    <td class="title" align='center' colspan=4>합계</td>
	            </tr>	
            </table>
	    </td>
	    <td class='line' width='60%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%	for(int i = 0 ; i < incom_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);%>
    		    <tr>
    				<td width='12%' align='center'>
    				 <a  href="javascript:MM_openBrWindow('unconfirm_reply.jsp?auth_rw=<%=auth_rw%>&incom_dt=<%=ht.get("INCOM_DT")%>&incom_seq=<%=ht.get("INCOM_SEQ")%>&incom_amt=<%=ht.get("INCOM_AMT")%>','Reply','scrollbars=no,status=yes,resizable=yes,width=450,height=220,left=50, top=50')">
    				 <%=ht.get("JUNG_ST_NM")%></a></td>
    				<td width='7%' align='center'><%=ht.get("RE_CHK")%></td>		
    		
    		        <td width='55%' align='center'><%=Util.subData(String.valueOf(ht.get("REASON")) + " - " +  String.valueOf(ht.get("REMARK")), 30 )%>&nbsp;</td>					
    		        <td width='15%' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("INCOM_AMT")))%></td>    		    
    		    </tr>
    	
    <%		total_amt  = total_amt  + Long.parseLong(String.valueOf(ht.get("INCOM_AMT")));
    	}	%>
    		    <tr>
                    <td class="title" align='center' colspan=3></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
                  
    	        </tr>	
    	    </table>
	    </td>
    </tr>
    <%	}else{%>                     
    <tr>
	    <td class='line' width='40%' id='td_con' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>&nbsp;</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='60%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
    		        <td>등록된 데이타가 없습니다</td>
    		    </tr>
    	    </table>
	    </td>
    </tr>
<% 	}%>
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=incom_size%>';
//-->
</script>

</body>
</html>


<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.incom.*, acar.util.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	
	String s_kd2 	= request.getParameter("s_kd2")==null? "":request.getParameter("s_kd2");
	String t_wd2 	= request.getParameter("t_wd2")==null? "" :request.getParameter("t_wd2");
	
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String bank_nm 	= request.getParameter("bank_nm")==null? "":request.getParameter("bank_nm");
	String bank_no 	= request.getParameter("bank_no")==null? "" :request.getParameter("bank_no");
	//조회용
	String bank_code 	= request.getParameter("bank_code")==null?"":request.getParameter("bank_code");
	String card_cd 		= request.getParameter("card_cd")==null?"":request.getParameter("card_cd");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt =  in_db.getIncomList(s_kd, t_wd, dt, ref_dt1, ref_dt2, bank_nm, bank_no, bank_code, card_cd, s_kd2, t_wd2);	
	int incom_size = vt.size();
	
	String value[] = new String[2];
	
	long total_amt = 0;
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
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
        <td class='line' width='42%' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                  <td width='14%' class='title'>연번</td>
                  <td width='17%' class='title'>입금구분</td>
                  <td width='20%' class='title'>은행(카드사)</td>
                  <td width='29%' class='title'>계좌(카드)번호</td>
                  <td width="20%" class='title'>거래일자</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='58%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
        		  <td width="19%" class='title'>처리내역</td>
        		  <td width="29%" class='title'>적요</td>
        		  <td width="17%" class='title'>입금액</td>
        		  <td width="35%" class='title'>내용</td>		          	     
        		</tr>
    	    </table>
	    </td>
    </tr>
    
  <%if(incom_size > 0){%>
    <tr>		
        <td class='line' width='42%' id='td_con' style='position:relative;'> 
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
                  <td width='14%' align='center'><%=i+1%></td>
                  <td width='17%' align='center'><%=ht.get("IP_ME_NM")%></td>         
         <%   if ( ht.get("IP_METHOD").equals("1") ) {  %>			
          		  <td width='20%' align='center'><%=value[1]%></td>
          		  <td width='29%' align='center'><%=ht.get("BANK_NO")%></td>
         <%    } else if ( ht.get("IP_METHOD").equals("2") ) { %>	       
                  <td width='20%' align='center'><%=ht.get("CARD_NM")%></td>
                  <td width='29%' align='center'><%=ht.get("CARD_NO")%></td>
         <%    } else { %>         
                  <td width='20%' align='center'>&nbsp;</td>
                  <td width='29%' align='center'>&nbsp;</td>
         <%    }  %>          
                
                  <td width='20%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%></td>
                </tr>              
                <%		}	%>
                
                <tr>
                    <td class="title" align='center' colspan=9>합계</td>
        	    </tr>			
            </table>
	    </td>
	    <td class='line' width='58%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < incom_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
        		<tr>
        		  <td width='19%' align='center'>
        		  <% if ( ht.get("JUNG_ST_NM").equals("완료") ||  ht.get("JUNG_ST_NM").equals("CMS") ||  ht.get("JUNG_ST_NM").equals("카드사입금완료")  ) {%>
        		  <a href="javascript:parent.view_incom('<%=ht.get("INCOM_DT")%>', '<%=ht.get("INCOM_SEQ")%>', '<%=ht.get("JUNG_ST_NM")%>', '<%=ht.get("INCOM_AMT")%>', '<%=ht.get("IP_METHOD")%>', '<%=ht.get("P_GUBUN")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><% } %> <%=ht.get("JUNG_ST_NM")%>
        		  <% if ( ht.get("JUNG_ST_NM").equals("완료")  ||  ht.get("JUNG_ST_NM").equals("CMS") ||  ht.get("JUNG_ST_NM").equals("카드사입금완료") ) {%></a><% } %>
        		 <% if ( ht.get("JUNG_ST_NM").equals("CMS")  && user_id.equals("000063") ) {%>
        		 <a href="javascript:parent.view_incom_cms('<%=ht.get("INCOM_DT")%>', '<%=ht.get("INCOM_SEQ")%>', '<%=ht.get("JUNG_ST_NM")%>', '<%=ht.get("INCOM_AMT")%>', '<%=ht.get("IP_METHOD")%>', '<%=ht.get("P_GUBUN")%>')" onMouseOver="window.status=''; return true" title="클릭하세요">
        		<% } else { %>&nbsp;<% } %> 
        	 	<% if ( ht.get("JUNG_ST_NM").equals("CMS") ) {%>.</a><% } %>
        		  </td>
        		  <td width='29%' align='left'><%=Util.subData(String.valueOf(ht.get("REMARK")), 18)%></td>					
        		  <td width='17%' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("INCOM_AMT")))%></td>
        		  <td width='35%' align='left'><span title='<%=ht.get("CARD_DOC_CONT")%>'><%=Util.subData(String.valueOf(ht.get("CARD_DOC_CONT")), 24)%></span></td>
        		</tr>
	
<%		
		total_amt  = total_amt  + Long.parseLong(String.valueOf(ht.get("INCOM_AMT")));
		}	%>

         		<tr>
                    <td class="title" align='center' colspan=2></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
                    <td class="title" align='center' ></td>
        	    </tr>	
	        </table>
	    </td>
    </tr>
 
 <%	}else{%>                     
    <tr>
	    <td class='line' width='42%' id='td_con' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>&nbsp;</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='58%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
    		        <td>등록된 데이타가 없습니다</td>
    		    </tr>
    	    </table>
	    </td>
    </tr>
<% 	}%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=incom_size%>';
//-->
</script>
</body>
</html>


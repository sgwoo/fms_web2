<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = vt = a_db.getHoldContList_20160614(s_kd, t_wd, andor, gubun2, gubun3, ck_acar_id);
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
<table border="0" cellspacing="0" cellpadding="0" width='1200'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='30%' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='10%' class='title' style='height:45'>연번</td>
                    <td width='10%' class='title'>결재</td>
                    <td width='27%' class='title'>계약번호</td>
                    <td width='23%' class='title'>계약일</td>
                    <td width="30%" class='title'>고객</td>
                </tr>
            </table>
    	</td>
    	<td class='line' width='70%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        	<tr>
                    <td colspan="4" class='title'>자동차</td>		
        	    <td colspan="5" class='title'>계약</td>				  
        	    <td colspan="2" class='title'>관리</td>										
        	</tr>
        	<tr>
        	    <td width="15%" class='title'>차종</td>
        	    <td width="9%" class='title'>차량번호</td>
        	    <td width="4%" class='title'>지역</td>		  
        	    <td width="9%" class='title'>관리번호</td>		  
        	    <td width='9%' class='title'>계약구분</td>
        	    <td width='9%' class='title'>영업구분</td>
        	    <td width='9%' class='title'>차량구분</td>
        	    <td width='9%' class='title'>용도구분</td>
        	    <td width='9%' class='title'>관리구분</td>		  
        	    <td width='9%' class='title'>최초영업자</td>
        	    <td width='9%' class='title'>영업대리인</td>
       		</tr>
	    </table>
	</td>
    </tr>
    <%if(cont_size > 0){%>
    <tr>		
        <td class='line' width='30%'10' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%	for(int i = 0 ; i < cont_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td width='10%' align='center'><%=i+1%></td>
                    <td width='10%' align='center'><%if(String.valueOf(ht.get("SANCTION_ST")).equals("요청")){%><font color=red><%}else{%><font color=#000000><%}%><%=ht.get("SANCTION_ST")%></font></td>		  
                    <td width='27%' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("FEE_RENT_ST")%>', '<%if(String.valueOf(ht.get("CNG_ST")).equals("")){%><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%><%}else{%><%if(String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=ht.get("CNG_ST")%><%}else{%><%=ht.get("EXT_ST2")%><%}%><%}%>', '<%=ht.get("SANCTION_ST")%>','<%=ht.get("REG_STEP")%>','<%=ht.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
                    <td width='23%' align='center'><%if(String.valueOf(ht.get("CNG_ST")).equals("계약승계")&&String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_DT")))%><%}else{%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%><%}%></td>
                    <td width='30%' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></span></td>
                </tr>
        <%		}	%>
            </table>
	    </td>
	    <td class='line' width='70%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
        		<tr>
        		    <td width='15%' align='center'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 7)%></td>
        		    <td width='9%' align='center'><%=ht.get("CAR_NO")%></td>					
        		    <td width='4%' align='center'><%=ht.get("CAR_EXT")%></td>
        		    <td width='9%' align='center'><%=ht.get("CAR_DOC_NO")%></td>
        		    <td width='9%' align='center'><%if(String.valueOf(ht.get("CNG_ST")).equals("")){%><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%><%}else{%><%if(String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=ht.get("CNG_ST")%><%}else{%><%=ht.get("EXT_ST2")%><%}%><%}%></td>
        		    <td width='9%' align='center'><%=ht.get("BUS_ST")%></td>
        		    <td width='9%' align='center'><%=ht.get("CAR_GU")%></td>
        		    <td width='9%' align='center'><%=ht.get("CAR_ST")%></td>
        		    <td width='9%' align='center'><%=ht.get("RENT_WAY")%></td>					
        		    <td width='9%' align='center'><%=ht.get("BUS_NM")%></td>					
        		    <td width='9%' align='center'><span title='<%=ht.get("BUS_AGNT_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("BUS_AGNT_NM")),3)%></span></td>										
        		</tr>
<%		}	%>
	        </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='30%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='70%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
        		    <td>&nbsp;</td>
        		</tr>
  	        </table>
	    </td>
    </tr>
<%	}	%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=cont_size%>';
//-->
</script>
</body>
</html>


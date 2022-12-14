<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.* "%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	int count =0;
	
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
			
	Vector vt = umd.getPurComClsList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt);
	int vt_size = vt.size();
		
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
<table border="0" cellspacing="0" cellpadding="0" width='1350'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='460' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='30' class='title'>연번</td>
                    <td width='30' class='title'>상태</td>
                    <td width='100' class='title'>특판계약번호</td>
                    <td width="100" class='title'>제조사</td>
                    <td width='200' class='title'>차명</td>        	    
                </tr>
            </table>
    	</td>
    	<td class='line' width='890'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
       		<tr>
        	    <td width="120" class='title'>영업소</td>
        	    <td width="200" class='title'>해지구분</td>
                    <td width='150' class='title'>해지등록</td>
                    <td width='150' class='title'>처리구분</td>
        	    <td width='200' class='title'>계약자</td>
        	    <td width='70' class='title'>최초영업자</td>
        	</tr>
	    </table>
	</td>
    </tr>
    <%if(vt_size > 0){%>
    <tr>		
        <td class='line' width='460' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%	for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
    				if(String.valueOf(ht.get("USE_YN_ST")).equals("") && String.valueOf(ht.get("CNG_CONT")).equals("신차취소현황으로 보내기")) continue;
    				count++;
    		%>
                <tr> 
                    <td width='30' align='center'><%=count%></td>                    
                    <td width='30' align='center'><%=ht.get("USE_YN_ST")%></td>                    
                    <td width='100' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("COM_CON_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("COM_CON_NO")%></a></td>
                    <td width='100' align='center'><%=ht.get("CAR_COMP_NM")%></td>
                    <td width='200' align='center'><span title='<%=ht.get("R_CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("R_CAR_NM")), 18)%></span></td>        	            	                        
                </tr>
        <%		}	%>
            </table>
	</td>
	<td class='line' width='890'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				if(String.valueOf(ht.get("USE_YN_ST")).equals("") && String.valueOf(ht.get("CNG_CONT")).equals("신차취소현황으로 보내기")) continue;
		%>
                <tr>
                    <td width='120' align='center'><%=ht.get("CAR_OFF_NM")%></td>
                    <td width='200' align='center'><%=ht.get("CNG_CONT")%></span></td>
                    <td width='150' align='center'><%=ht.get("REG_DT")%></td>
                    <td width='150' align='center'><%=ht.get("CNG_DT")%><%if(String.valueOf(ht.get("CNG_DT")).equals("")){%><font color=red>미반영</font><%}%></td>
        	    <td width='200' align='center'><span title='<%=ht.get("PUR_COM_FIRM")%>'><%=AddUtil.subData(String.valueOf(ht.get("PUR_COM_FIRM")), 16)%></span></td>				
        	    <td width='70' align='center'><%=ht.get("BUS_NM")%></td>	        		    
                </tr>
<%		}	%>
	    </table>
	</td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='460' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
	</td>
	<td class='line' width='890'>			
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
	parent.document.form1.size.value = '<%=count%>';
//-->
</script>
</body>
</html>


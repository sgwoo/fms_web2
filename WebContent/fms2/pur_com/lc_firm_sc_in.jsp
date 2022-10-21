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
	
			
	Vector vt = umd.getPurComLcFirmList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt);
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
<table border="0" cellspacing="0" cellpadding="0" width='1490'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='530' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='30' class='title'>연번</td>                    
                    <td width='100' class='title'>계약번호</td>
                    <td width='75' class='title'>계약등록일</td>
                    <td width="75" class='title'>출고희망일</td>        	    
                    <td width='100' class='title'>제조사</td>
                    <td width='150' class='title'>차명</td>
                </tr>
            </table>
    	</td>
    	<td class='line' width='960'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
       		<tr>
        	    <td width="120" class='title'>영업소</td>
        	    <td width="150" class='title'>선택사양</td>
        	    <td width="100" class='title'>색상</td>		  
        	    <td width="40" class='title'>T/M</td>
        	    <td width="70" class='title'>과세구분</td>		  
        	    <td width='80' class='title'>소비자가</td>
        	    <td width='60' class='title'>인수지</td>
        	    <td width='100' class='title'>계약자</td>
        	    <td width='70' class='title'>고객구분</td>
        	    <td width='70' class='title'>최초영업자</td>
        	    <td width='100' class='title'>영업구분</td>        	    
        	</tr>
	    </table>
	</td>
    </tr>
    <%if(vt_size > 0){%>
    <tr>		
        <td class='line' width='530' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%	for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td width='30' align='center'><%=i+1%></td>                    
                    <td width='100' align='center'>
                        <%if(String.valueOf(ht.get("CLS_YN")).equals("취소건") && String.valueOf(ht.get("PUR_REQ_DT")).equals("즉시")){%>
                            <%=ht.get("RENT_L_CD")%>
                        <%}else{%>
                            <a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a>
                        <%}%>
                    </td>
                    <td width='75' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                    <td width='75' align='center'><%=ht.get("PUR_REQ_DT")%></td>        	    
                    <td width='100' align='center'><%=ht.get("CAR_COMP_NM")%></td>        	    
                    <td width='150' align='center'><span title='<%=ht.get("CAR_NAME")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NAME")), 12)%></span></td>
                </tr>
        <%		}	%>
            </table>
	</td>
	<td class='line' width='960'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr>
        	    <td width='120' align='center'><%=ht.get("CAR_OFF_NM")%></td>                    
        	    <td width='150' align='center'><span title='<%=ht.get("OPT")%>'><%=AddUtil.subData(String.valueOf(ht.get("OPT")),12)%></span></td>					
        	    <td width='100' align='center'><span title='<%=ht.get("COLO")%>/<%=ht.get("IN_COL")%>/<%=ht.get("GARNISH_COL")%>'><%=AddUtil.subData(String.valueOf(ht.get("COLO"))+""+String.valueOf(ht.get("IN_COL")),7)%></span></td>
        	    <td width='40' align='center'><%=ht.get("AUTO")%></td>                    
        	    <td width='70' align='center'><%=ht.get("PURC_GU")%></td>
        	    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_AMT")))%></td>
        	    <td width='60' align='center'><%=ht.get("UDT_ST")%></td>
        	    <td width='100' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></span></td>				
        	    <td width='70' align='center'><%=ht.get("CLIENT_ST_NM")%></td>
        	    <td width='70' align='center'><%=ht.get("BUS_NM")%></td>	        		            	    
        	    <td width='100' align='center'><%=ht.get("PUR_BUS_ST")%></td>
                </tr>
<%		}	%>
	    </table>
	</td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='530' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
	</td>
	<td class='line' width='960'>			
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
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>


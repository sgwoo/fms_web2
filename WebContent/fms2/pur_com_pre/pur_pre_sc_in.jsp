<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.* "%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
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
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���

	
	int count =0;
	
	Vector vt = cop_db.getCarOffPreList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt);
	int vt_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	/* Title ���� */
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
<table border="0" cellspacing="0" cellpadding="0" width='2040'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='510' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='30' class='title'>����</td>
                    <td width='100' class='title'>�������</td>
                    <td width='100' class='title'>�����ȣ</td>
                    <td width='130' class='title'>����Ͻ�</td>
                    <td width='150' class='title'>����</td>
                </tr>
            </table>
    	</td>
    	<td class='line' width='1530'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
       		<tr>
        	    <td width="250" class='title'>���</td>
        	    <td width="150" class='title'>�������</td>		  
        	    <td width="100" class='title'>�������</td>		  
        	    <td width='80' class='title'>�Һ��ڰ�</td>
        	    <td width='60' class='title'>����</td>
        	    <td width='90' class='title'>����������</td>
              <td width="80" class='title'>�������</td>
        	    <td width='60' class='title'>������</td>
        	    <td width='80' class='title'>������</td>
        	    <td width='200' class='title'>����ȣ</td>
        	    <td width='100' class='title'>���ּ�</td>
        	    <td width='100' class='title'>����ȣ</td>
        	    <td width='80' class='title'>�����</td>
        	    <td width='100' class='title'>�������������</td>
        	</tr>
	    </table>
	</td>
    </tr>
    <%if(vt_size > 0){%>
    <tr>		
        <td class='line' width='510' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%	for(int i = 0 ; i < vt_size ; i++){
    							Hashtable ht = (Hashtable)vt.elementAt(i);
    							
    							String td_color = "";
									if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
    			
    			%>
                <tr> 
                    <td <%=td_color%> width='30' align='center'><%=i+1%></td>
                    <td <%=td_color%> width='100' align='center'><%=ht.get("CAR_OFF_NM")%></td>        	                        
                    <td <%=td_color%> width='100' align='center'><a href="javascript:parent.view_cont('<%=ht.get("SEQ")%>')" onMouseOver="window.status=''; return true"><%=ht.get("COM_CON_NO")%></a></td>
                    <td <%=td_color%> width='130' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                    <td <%=td_color%> width='150' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>
                </tr>
        <%		}	%>
            </table>
	</td>
	<td class='line' width='1530'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							
							String td_color = "";
							if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
				
				%>
                <tr>
        	    <td <%=td_color%> width='250' align='center'><span title='<%=ht.get("OPT")%>'><%=AddUtil.subData(String.valueOf(ht.get("OPT")),20)%></span></td>					
        	    <td <%=td_color%> width='150' align='center'><span title='<%=ht.get("COLO")%>'><%=AddUtil.subData(String.valueOf(ht.get("COLO")),10)%></span></td>
        	    <td <%=td_color%> width='100' align='center'><span title='<%=ht.get("IN_COL")%>'><%=AddUtil.subData(String.valueOf(ht.get("IN_COL")),6)%></span></td>
        	    <td <%=td_color%> width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_AMT")))%></td>
        	    <td <%=td_color%> width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CON_AMT")))%></td>
        	    <td <%=td_color%> width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CON_PAY_DT")))%></td>
        	    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_EST_DT")))%></td>
        	    <td <%=td_color%> width='60' align='center'><%=ht.get("BUS_NM")%></td>
        	    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RES_REG_DT")))%></td>
        	    <td <%=td_color%> width='200' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 12)%></span></td>				
        	    <td <%=td_color%> width='100' align='center'><span title='<%=ht.get("ADDR")%>'><%=AddUtil.subData(String.valueOf(ht.get("ADDR")), 7)%></span></td>				
        	    <td <%=td_color%> width='100' align='center'><%=ht.get("RENT_L_CD")%></td>
        	    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>
        	    <td <%=td_color%> width='100' align='center'><font color=red><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></font></td>
                </tr>
<%		}	%>
	    </table>
	</td>
<%	}else{	%>
    <tr>		
        <td class='line' width='510' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
            </table>
	</td>
	<td class='line' width='1530'>
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


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

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���

	
	int count =0;
	
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
			
	Vector vt = umd.getPurComOrderList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt);
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
<table border="0" cellspacing="0" cellpadding="0" width='1430'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='410' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='30' class='title'>����</td>
                    <td width='30' class='title'>����</td>
                    <td width='100' class='title'>Ư�ǰ���ȣ</td>
                    <td width="100" class='title'>������</td>
                    <td width='150' class='title'>����</td>        	    
                </tr>
            </table>
    	</td>
    	<td class='line' width='1010'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
       		<tr>
        	    <td width="120" class='title'>������</td>
        	    <td width="100" class='title'>����</td>
                    <td width='150' class='title'>��Ȯ��</td>
                    <td width='150' class='title'>ó������</td>
                    <td width="80" class='title'>��������</td>       		
                    <td width="80" class='title'>�������</td>       		
                    <td width="80" class='title'>��������</td>
                    <td width="80" class='title'>�������</td>
        	    <td width='100' class='title'>�����</td>
        	    <td width='70' class='title'>���ʿ�����</td>
        	</tr>
	    </table>
	</td>
    </tr>
    <%if(vt_size > 0){%>
    <tr>		
        <td class='line' width='410' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%	for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td width='30' align='center'><%=i+1%></td>                    
                    <td width='30' align='center'><%=ht.get("USE_YN_ST")%></td>                    
                    <td width='100' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("COM_CON_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("COM_CON_NO")%></a></td>
                    <td width='100' align='center'><%=ht.get("CAR_COMP_NM")%></td>
                    <td width='150' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>        	    
                </tr>
        <%		}	%>
            </table>
	</td>
	<td class='line' width='1010'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr>
                    <td width='120' align='center'><%=ht.get("CAR_OFF_NM")%></td>
                    <td width='100' align='center'>�ֹ���</td>
                    <td width='150' align='center'><%=ht.get("ORDER_REQ_DT")%></td>
                    <td width='150' align='center'><%=ht.get("ORDER_CHK_DT")%><%if(String.valueOf(ht.get("ORDER_CHK_DT")).equals("")){%><font color=red>��Ȯ��</font><%}%></td>
                    <td width='80' align='center'><%=ht.get("DLV_ST_NM")%></td>
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_EST_DT")))%></td>                
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_CON_DT")))%></td>
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>
        	    <td width='100' align='center'><span title='<%=ht.get("PUR_COM_FIRM")%>'><%=AddUtil.subData(String.valueOf(ht.get("PUR_COM_FIRM")), 7)%></span></td>				
        	    <td width='70' align='center'><%=ht.get("BUS_NM")%></td>	        		    
                </tr>
<%		}	%>
	    </table>
	</td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='410' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
            </table>
	</td>
	<td class='line' width='1010'>			
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


<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_office.*" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank 	= request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String g_fm	 	= request.getParameter("g_fm")==null?"":request.getParameter("g_fm");
	String dt		= request.getParameter("dt")==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String sort 	= request.getParameter("sort")==null?gubun2:request.getParameter("sort");
	
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm"); //��������̸� �˻�
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	Vector cars = umd.getCarOffEmpRentStat(dt, ref_dt1, ref_dt2, gubun2, gubun3, gubun4, gubun5, sort, gubun_nm);
	int car_size = cars.size();	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
/* Title ���� */
function setupEvents()
{
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
}

function moveTitle()
{
    var X ;
    document.all.title.style.pixelTop = document.body.scrollTop ;
                                                                              
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;   
    
}
function init() {
	
	setupEvents();
}
	function open_caremp(emp_id){
		var SUBWIN="/acar/car_office/rent_emp_list.jsp?emp_id="+emp_id+"&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun2=<%=gubun2%>";	
		window.open(SUBWIN, "MailUp", "left=100, top=100, width=850, height=500, scrollbars=yes");
	}		
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
</head>
<body onLoad="javascript:init()">
<form name='form1' method='post' target='d_content' action='/acar/car_rent/con_reg_frame.jsp'>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="100%">
                <tr>
                    <td class=line2></td>
                </tr>
                <tr id='title' style='position:relative;z-index:1'>            		
                    <td class=line id='title_col0' style='position:relative;'> 
            	  		<table border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td width=5% class=title >����</td>
                                <td width=14% class=title>�Ҽӻ�</td>
                                <td width=25% class=title>�ٹ�ó</td>
                                <td width=10% class=title>����</td>
                                <td width=11% class=title>����</td>
                                <td width=10% class=title>���Ǽ�</td>
                                <td width=10% class=title>�����</td>
                                <td width=15% class=title>��������</td>
                            </tr>
                        </table>
		            </td>
		        </tr>
<%	if(car_size != 0){%>
                <tr>            		
                    <td class=line id='D1_col' style='position:relative;'> 
		                <table border=0 cellspacing=1 width=100%>
<%		int  t_cnt[] = new int[17];
		for(int i = 0 ; i < car_size ; i++){
			Hashtable car = (Hashtable)cars.elementAt(i);
			t_cnt[0] += AddUtil.parseInt(String.valueOf(car.get("CONT_CNT")));
			%>
                            <tr> 
                                <td align="center" width=5%><%= i+1%></td>
                                <td align="center" width=14%><%=car.get("NM")%></td>
                                <td align="center" width=25%><%=car.get("CAR_OFF_NM")%></td>
                                <td align="center" width=10%><%=car.get("EMP_NM")%></td>
                                <td align="center" width=11%><%=car.get("EMP_POS")%></td>
                                <td width=10% align="center"><a href="javascript:open_caremp('<%=car.get("EMP_ID")%>')"><%=car.get("CONT_CNT")%>��</a></td>
                                <td width=10% align="center"><%if(String.valueOf(car.get("AGENT_ST")).equals("������Ʈ")){%><%=car.get("AGENT_ST")%><%}else{%><%=car.get("USER_NM")%><%}%></td>
                                <td width=15% align="center"><%=car.get("CNG_RSN")%></td>
                            </tr>
        <%		}%>
                            <tr> 
                                <td class=title align="center">&nbsp;</td>
                                <td class=title align="center">&nbsp;</td>
                                <td class=title align="center">&nbsp;</td>
                                <td class=title align="center">�հ�</td>
                                <td class=title align="center">&nbsp;</td>
                                <td class=title align="center"><%=t_cnt[0]%>��</td>
                                <td class=title align="center">&nbsp;</td>
                                <td class=title align="center">&nbsp;</td>
                            </tr>
                        </table>
		            </td>            		            		
          
<%	}else{%>
	            <tr>            		
                    <td class=line id='D1_col' style='position:relative;'> 
		                <table border=0 cellspacing=1 width=100%>
                            <tr> 
                                <td align="center">&nbsp;��ϵ� ����Ÿ�� �����ϴ�.</td>
                            </tr>
                        </table>
		            </td>            		            		
		            		
                </tr>
<%	}%>
            </table>
        </td>
  </tr>
</table>
</form>
</body>
</html>
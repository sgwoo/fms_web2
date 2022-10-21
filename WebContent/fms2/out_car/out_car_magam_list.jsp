<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<%
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"0":request.getParameter("dt");
	String t_st_dt = request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");
	String t_end_dt = request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	Vector stats = new Vector();
	
	stats = oc_db.Magam_ListSearch(save_dt);
	
	int stat_size = stats.size();
	
	long total_amt 	= 0;
	long total_amt2 	= 0;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='../../include/table_t.css'>
<script language='javascript'>
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
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
-->
</script>
</head>
<body>
<form name='form1' method='post'>
	 <input type='hidden' name='save_dt' value='<%=save_dt%>'>
<table border=0 cellspacing=0 cellpadding='0' width='700'>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td align='center'><%=save_dt%>�Ͽ� ������ ��ü�����Ȳ ��������Ʈ</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class=line >
			<table border=0 cellspacing=1 cellpadding=0 width='700'>
				<tr>
					<td class='title' width='50'>����</td>
            		<td class='title' width='100'>����</td>
            		<td class='title' width='100'>�����</td>
            		<td class='title' width='100'>�����</td>
            		<td class='title' width='150'>�������</td>
            		<td class='title' width='100'>�����ȣ</td>
            		<td class='title' width='100'>����ȿ��</td>
    				<!--<td class='title' width='100'>����ȿ��_2</td>-->
				</tr>
			</table>
		</td>
	</tr>
<%
	if(stat_size > 0)
	{
%>
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 cellpadding='0' width='700'>
<%
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
%>            	
           		<tr>
           			<td align='center' width='50'><%=i+1%></td>
            		<td align='center' width='100'>&nbsp;<span title='<%=stat.get("CAR_NM")%>'><%=Util.subData(String.valueOf(stat.get("CAR_NM")), 6)%></span></td>
                    <td align='center' width='100'><%=stat.get("DLV_DT")%></td>
                    <td align='center' width='100'><%=stat.get("INIT_REG_DT")%></td>
                    <td align='center' width='150'>&nbsp;<%=stat.get("DLV_OFF")%></td>
                    <td align='center' width='100'><%=stat.get("CAR_NUM2")%></td>
            		<td align='right' width='100'><%=AddUtil.parseDecimal(String.valueOf(stat.get("BC_S_F")))%>&nbsp;</td>
    				<!--<td align='right' width='100'><%=AddUtil.parseDecimal(String.valueOf(stat.get("BC_S_F2")))%>&nbsp;</td>-->
           		</tr>
<%
			total_amt 	= total_amt + AddUtil.parseInt(String.valueOf(stat.get("BC_S_F")));
			total_amt2 	= total_amt2 + AddUtil.parseInt(String.valueOf(stat.get("BC_S_F2")));
		}
%>
           		<tr>
           			<td class="title" colspan="6">�հ� </td>					
           			<td class="title"  style='text-align:right'><%=Util.parseDecimal(total_amt)%>&nbsp;</td>
    				<!--<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%>&nbsp;</td>-->
           		</tr>
			</table>
		</td>
	</tr>
<%
	}
	else
	{
%>
	<tr>
		<td class=line >
			<table border=0 cellspacing=1 cellpadding='0' width='700'>
				<tr>
					<td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
				</tr>
			</table>
		</td>
	</tr>
<%
	}
%>
</table>
</form>
</body>
</html>
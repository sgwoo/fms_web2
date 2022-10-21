<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*, java.*, java.text.SimpleDateFormat"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
		
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String park_id = request.getParameter("park_id")==null?"1":request.getParameter("park_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String values = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&brid="+brid+
			"&gubun1="+gubun1+"&gubun2="+gubun2+"&start_dt="+start_dt+"&end_dt="+end_dt+
			"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+
		   	"&sh_height="+sh_height;
	
	Vector vt = pk_db.getParkWashDayList(park_id, gubun1, gubun2, car_no, start_dt, end_dt, off_id);
	int vt_size = vt.size();
	
	Date today = new Date();	        
	SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat time = new SimpleDateFormat("hh:mm");

	String year = date.format(today);
	String ms = time.format(today);
%>


<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<style type="text/css" media="print">
    @page {
        size:  auto;
        margin: 5mm 0mm 0mm 0mm;
    }
    html {
        background-color: #FFFFFF;
        margin: 0px;
    }
    body {
    	-webkit-print-color-adjust: exact; 
    	-ms-print-color-adjust: exact; 
    	color-adjust: exact;
    	transform: scale(.9);    	
        /* margin���� ����Ʈ ���� ���� */
        /* IE */
        margin: 0mm 0mm 0mm 0mm;
        
        /* CHROME */
        -webkit-margin-before: 0mm; /*���*/
		-webkit-margin-end: 0mm; /*����*/
		-webkit-margin-after: 0mm; /*�ϴ�*/
		-webkit-margin-start: 0mm; /*����*/
    }
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script>

	
	function pagesetPrint(){
		IEPageSetupX.header='';
		IEPageSetupX.footer='';
		IEPageSetupX.leftMargin=5;
		IEPageSetupX.rightMargin=5;
		IEPageSetupX.topMargin=20;
		IEPageSetupX.bottomMargin=20;		
		print(); 
	}
	
	function ieprint() {
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= false; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 10.0; //��������   
		factory.printing.rightMargin 	= 10.0; //��������
		factory.printing.topMargin 	= 5.0; //��ܿ���    
		factory.printing.bottomMargin 	= 5.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}
	
	function onprint() {
		var userAgent=navigator.userAgent.toLowerCase();
		
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			ieprint();
		}
	}

</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form name='form1' action='park_wa_sc.jsp' method='post' target='c_foot'>
    <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td>
	    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����(����) �۾����� ��Ȳ</span>
	    </td>
	</tr>
	<tr>
		<td align="right">
			<span id=""><%=year%>, <%=ms%></span> ����&nbsp;
		</td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class="line" >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
               <tr>
                    <td width='2%' rowspan='2' class='title'>����</td>
                    <td width='15%' colspan="3" class='title'>�۾����</td>
                    <td width='15%' colspan="2" class='title'>�۾�����</td>
                    <td width='6%' colspan="2" class='title'>�۾���û��</td>
                    <td width='10%' colspan="2" class='title'>�����Ȳ</td>
                    <td width='10%' colspan="2" class='title'>���������</td>
                    <td width='10%' colspan="2" class='title'>�������</td>
                </tr>
                <tr>
                	<td class='title'>������ȣ</td>
                	<td class='title'>�� ��</td>
                	<td class='title'>������ġ</td>
                	<td class='title'>�������</td>
                	<td class='title'>�۾���û����</td>
                	<td class='title'>����</td>
                	<td class='title'>�ǳ�</td>
                	<td class='title'>����</td>
                	<td class='title'>�Ϸ�ð�</td>
                	<td class='title'>�̸�</td>
                	<td class='title'>����ó</td>
                	<td class='title'>��Ͽ���</td>
                	<td class='title'>�����</td>
                </tr>
                <% 
				    if( vt_size > 0) {
						for(int i = 0 ; i < vt_size ; i++) {
							Hashtable ht = (Hashtable)vt.elementAt(i);
				%>
				<tr>
                	<td align="center"><%=i+1%></td>
                	<td align="center" id="car_no<%=i%>"><%=ht.get("CAR_NO")%></td>
                	<td align="center"><%=ht.get("CAR_NM")%></td>
                	<td align="center">
                		<%=ht.get("PARK_NM")%>
                		<% if (!ht.get("AREA").equals("")) { %>
                			&nbsp;<font style="color: blue; font-weight: bold;"><%=ht.get("AREA")%></font>
                		<% } %>
                	</td>
                	<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                	<td align="center"><%=ht.get("F_REQ_DT")%></td>
                	<td align="center">
                		<input type="checkbox" name="wash_pay" id="wash_pay<%=i%>"
                		 <%if(!ht.get("WASH_PAY").equals("")){%>checked<%}%> <%if(!String.valueOf(ht.get("GUBUN_ST2")).equals("")){%>onclick="return false;<%}%>">
                	</td>
                	<td align="center"><input type="checkbox" name="inclean_pay" id="inclean_pay<%=i%>"
                		<%if(!ht.get("INCLEAN_PAY").equals("")){%>checked<%}%> <%if(!String.valueOf(ht.get("GUBUN_ST2")).equals("")){%>onclick="return false;<%}%>">
                	
                	</td>
                	<td align="center">
                		<%	if(!String.valueOf(ht.get("GUBUN_ST2")).equals("")){%>
                			<%=ht.get("GUBUN_ST2")%>
                		<%}else{%>
               				<a href="javascript:sendMsg(<%=i%>,<%=ht.get("SEQ")%>);"><img src=/acar/images/center/button_in_conf.gif align=absmiddle border=0"></a>	
                		<%	}%>
                	
                	</td>
                	
                	<td align="center"><%if(!ht.get("F_WASH_END").equals("")){%><%=ht.get("F_WASH_END")%><%} %></td>
                	<td align="center"><%=ht.get("USERS_COMP")%></td>
                	<td align="center"><%=ht.get("USER_M_TEL")%></td>
                	<%if(!String.valueOf(ht.get("WASH_ETC")).equals("")){ %>
	                	<td align="center"><%=ht.get("WASH_ETC")%></td>
                	<%}else{%>
                		<td align="center">�۾����ð�</td>
                	<%}%>
                	<td align="center"><%=ht.get("USER_NM")%></td>
                </tr>
				<%  }
  					} else { %>
				<tr height="40">
					<td colspan="14" align="center">�����Ͱ� �����ϴ�.</td>
				</tr>
			 	<% 
			 		} %>
             </table>
		</td>
	</tr>         
  </table>
</form>
</body>
</html>

<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
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
	
	//�� ����
	function view_client(m_id, l_cd, r_st){
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String reg_dt = request.getParameter("dt")==null?"":request.getParameter("dt");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	String rent="";
	int total_su = 0;
	long total_amt = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddForfeitHanDatabase afm_db = AddForfeitHanDatabase.getInstance();
	
	Vector fines = new Vector();
	fines = afm_db.getSFineListday(reg_dt, gov_id, gubun1);
	int fine_size = fines.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=fine_size%>'>
<input type='hidden' name='reg_dt' value='<%=reg_dt%>'>
<input type='hidden' name='gov_id' value='<%=gov_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<table border="0" cellspacing="0" cellpadding="0" width='2000'>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar colspan='20'>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;������ > ���·���� > <span class=style1><span class=style5><%if(gov_id.equals("278")){%>�ѱ����ΰ���<%}else if(gov_id.equals("police")){%>���������� <%}%>���·Ḯ��Ʈ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='25%' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='16%' class='title'>����</td>
                    <td width='12%' class='title'>����</td>
                    <td width='21%' class='title'>����ȣ</td>
                    <td width='31%' class='title'>��ȣ</td>
                    <td width="20%" class='title'>������ȣ</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='75%'>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=7% class='title'>����</td>
                    <td width=5% class='title'>���Ǳ���</td>
                    <td width=5% class='title'>����������</td>
                    <td width=5% class='title'>���α���</td>
                    <td width=7% class='title'>û�����</td>
                    <td width=9% class='title'>�����Ͻ�</td>
                    <td width=9% class='title'>�������</td>
                    <td width=7% class='title'>���ݳ���</td>
                    <td width=11% class='title'>��������ȣ</td>
                    <td width=7% class='title'>���αݾ�</td>
                    <td width=5% class='title'>���α���</td>
                    <td width=5% class='title'>��������</td>
                    <td width=5% class='title'>û������</td>
                    <td width=5% class='title'>��������</td>
                    <td width=4% class='title'>�����</td>
                    <td width=4% class='title'>��ĵ����</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	if(fine_size > 0){%>
    <tr>
	    <td class='line' width='25%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < fine_size ; i++){
									Hashtable fine = (Hashtable)fines.elementAt(i);
					%>
                <tr> 
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='16%' align='center'><%=i+1%><%if(fine.get("USE_YN").equals("N")){%>(�ؾ�)<%}%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='12%' align='center'><%=fine.get("GUBUN")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='21%' align='center'><%=fine.get("RENT_L_CD")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width='31%' align='center'>
                      <%if(fine.get("FIRM_NM").equals("(��)�Ƹ���ī") && !fine.get("CUST_NM").equals("")){%>
                      <span title='(<%=fine.get("RES_ST")%>)<%=fine.get("CUST_NM")%>'><a href="javascript:view_client('<%=fine.get("RENT_MNG_ID")%>','<%=fine.get("RENT_L_CD")%>', '<%=fine.get("RENT_ST")%>')" onMouseOver="window.status=''; return true">(<%=fine.get("RES_ST")%>)<%=Util.subData(String.valueOf(fine.get("CUST_NM")), 6)%></a></span>	
                      <%}else{%>
                      <span title='<%=fine.get("FIRM_NM")%>'><a href="javascript:view_client('<%=fine.get("RENT_MNG_ID")%>', '<%=fine.get("RENT_L_CD")%>', '<%=fine.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(fine.get("FIRM_NM")), 11)%></a></span> 
                      <%}%>
                    </td>
                    <td width=20% align='center' <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%>><span title='���ʵ�Ϲ�ȣ:<%=fine.get("FIRST_CAR_NO")%>'><%=fine.get("CAR_NO")%></span></td>
                </tr>
          <%		}%>
            </table>
        </td>
	    <td class='line' width='75%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < fine_size ; i++){
									Hashtable fine = (Hashtable)fines.elementAt(i);%>
                <tr> 
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=7% align='center'><span title='<%=fine.get("CAR_NM")%>'><%=Util.subData(String.valueOf(fine.get("CAR_NM")), 8)%></span></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=fine.get("FAULT_ST")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=c_db.getNameById((String)fine.get("FAULT_NM"), "USER")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=fine.get("PAID_ST")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=7% align='center'><span title='<%=fine.get("GOV_NM")%>'><%=Util.subData(String.valueOf(fine.get("GOV_NM")), 6)%></span></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=9% align='center'><%=fine.get("VIO_DT")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=9% align='center'><span title='<%=fine.get("VIO_PLA")%>'><%=Util.subData(String.valueOf(fine.get("VIO_PLA")), 8)%></span></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=7% align='center'><span title='<%=fine.get("VIO_CONT")%>'><%=Util.subData(String.valueOf(fine.get("VIO_CONT")), 5)%></span></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=11% align='center'><span title='<%=fine.get("PAID_NO")%>'><%=Util.subData(String.valueOf(fine.get("PAID_NO")), 23)%></span></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=7% align='right'><%=Util.parseDecimal(String.valueOf(fine.get("PAID_AMT")))%>��&nbsp;</td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=fine.get("PAID_END_DT")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=fine.get("PROXY_DT")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=fine.get("DEM_DT")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center'><%=fine.get("COLL_DT")%></td>
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=4% align='center'><%=c_db.getNameById((String)fine.get("MNG_ID"), "USER")%></td>					
                    <td <%if(fine.get("USE_YN").equals("N")){%>class='is'<%}%> width=4% align='center'><%=fine.get("FILE_1_CNT")%>��</td>
                </tr>
          <%		}%>
            </table>
	    </td>
    </tr>
<%	}else{%>
    <tr>
	    <td class='line' width='25%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='75%'>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
	        </table>
	    </td>
    </tr>
<% 	}%>
</table>
</form>
</body>
</html>

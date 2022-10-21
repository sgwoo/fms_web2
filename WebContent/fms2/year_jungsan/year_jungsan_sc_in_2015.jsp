<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	
	String dt	= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String gubun1	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String minus	= request.getParameter("minus")==null?"":request.getParameter("minus");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"))-200;//��ܱ���
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = ac_db.Year_jungsan_List("2015", gubun1, gubun2);
	int vt_size = vt.size();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	

	
	
%>

<html>
<head><title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	var popObj = null;
	
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
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//÷������ ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	
		theURL = "https://fms3.amazoncar.co.kr/data/year_jungsan/"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();
	}

	//Ȯ��ó��
	function yend_dt(c_yy, sa_no){
	
		var fm = document.form1;
		
		if(confirm('�Ϸ�ó�� �Ͻðڽ��ϱ�?')){	
		fm.action="year_end_dt_a.jsp?c_yy="+c_yy+"&sa_no="+sa_no;		
		fm.target='i_no';
		fm.submit();
		}
	}
	
	//Ȯ�� ��� ó��
	function yend_dt_cancel(c_yy, sa_no){
	
		var fm = document.form1;
		
		if(confirm('�Ϸ� ���ó�� �Ͻðڽ��ϱ�?')){	
		fm.action="year_end_dt_a.jsp?c_yy="+c_yy+"&sa_no="+sa_no+"&cmd=del";		
		fm.target='i_no';
		fm.submit();
		}
	}
	

//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type="hidden" name="form" value="/fms2/year_jungsan/yaer_jungsan_sc_in_2015.jsp">
<input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'> 
		<td class='line' width='100%' id='td_title' style='position:relative;'>
			<table border=0 cellspacing=1 width=100%>
			<tbody>
			    <tr>
				  <td width="4%" colspan="1" rowspan="3" align="center" class="title">����</td>
				  <td width="10%" colspan="1" rowspan="3" align="center" class="title">��Ȳ</td>
				  <td width="9%" colspan="1" rowspan="3" align="center" class="title">�μ���</td>
				  <td width="7%" colspan="1" rowspan="3" align="center" class="title">�����ȣ</td>
				  <td width="7%" colspan="1" rowspan="3" align="center" class="title">����</td>
				  <td width="7%" colspan="1" rowspan="3" align="center" class="title">�ٷμҵ��� �ҵ�-���װ��� �Ű�</td>
				  <td width="21%" colspan="3" rowspan="1" align="center" class="title">�����������</td>
				  <td width="35%" colspan="5" rowspan="1" align="center" class="title">������������</td>
				</tr>
				<tr>
				  <td width="7%" colspan="1" rowspan="2" align="center" class="title">����û ����ȭ����(PDF)</td>
				  <td width="7%" colspan="1" rowspan="2" align="center" class="title">��α�(����û�ڷῡ �����Ե� ��α� ������)</td>
				  <td width="7%" colspan="1" rowspan="2" align="center" class="title">��α� ���� ��Ÿ(����û�ڷῡ �����Եȸ�� ��������)</td>
				  <td width="7%" align="center" class="title">�ֹε�ϵ</td>
				  <td width="7%" align="center" class="title">������������(����)</td>
				  <td width="7%" align="center" class="title">������������(�����)</td>
				  <td width="7%" align="center" class="title">�����(�ź����纻��)</td>
				  <td width="7%" align="center" class="title">��������</td>
				</tr>
				<tr>
				  <td width="35%" colspan="5" rowspan="1" align="center" class="title"><b>����� ������ ��� �������� �ʽ��ϴ�.</b></td>
				</tr>
			</tbody>
			</table>
		</td>
	</tr>
	<tr>
		<td class=line2>
			<table border=0 cellspacing=1 width=100%>
<%
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			u_bean = umd.getUsersBean(String.valueOf(ht.get("REG_ID")));
			String user_nm = u_bean.getUser_nm();
			String dept_id = u_bean.getDept_id();
			String dept_nm = u_bean.getDept_nm();
			String id = u_bean.getId();
%>             	
				<tr>
            		<td width='4%' align="center"><%=i+1%></td>
					<td width='10%' align="center"><%if(user_id.equals("000004") && ht.get("END_DT").equals("")){%><a href="javascript:yend_dt('<%=ht.get("C_YY")%>','<%=ht.get("SA_NO")%>')"><img src=/acar/images/center/button_in_dec.gif border=0 align=absmiddle></a><%}else{%><%=AddUtil.ChangeDate2((String)ht.get("END_DT"))%><%}%>
					<%if(user_id.equals("000004") && !ht.get("END_DT").equals("")){%>
					<a href="javascript:yend_dt_cancel('<%=ht.get("C_YY")%>','<%=ht.get("SA_NO")%>')">D</a>
					<%}%>
					</td>
            		<td width='9%' align="center"><%=dept_nm%></td>
					<td width='7%' align="center"><%=ht.get("SA_NO")%></td>
					<td width='7%' align="center"><%=user_nm%></td>
					<td width='7%' align="center">
					<%if(user_id.equals(ht.get("REG_ID"))||user_id.equals("000004")){%>
					<%if(!ht.get("FILE_NAME1").equals("")){%>
					<a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME1")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
						<%}%>
						<%}%>                                        
					</td>
					<td width='7%' align="center">
					<%if(user_id.equals(ht.get("REG_ID"))||user_id.equals("000004")){%>
					<%if(!ht.get("FILE_NAME2").equals("")){%>
					<a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME2")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
						<%}%>
						<%}%>                                        
					</td>
					<td width='7%' align="center">
					<%if(user_id.equals(ht.get("REG_ID"))||user_id.equals("000004")){%>
					<%if(!ht.get("FILE_NAME3").equals("")){%>
					<a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME3")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					<%}%>
						<%}%>
						<%if(ht.get("FILE3_YN").equals("Y")){%>����<%}%>
					</td>
					<td width='7%' align="center">
					<%if(user_id.equals(ht.get("REG_ID"))||user_id.equals("000004")){%>
					<%if(!ht.get("FILE_NAME4").equals("")){%>
					<a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME4")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					<%}%>
						<%}%>
						<%if(ht.get("FILE4_YN").equals("Y")){%>����<%}%>
					</td>
					<td width='7%' align="center">
					<%if(user_id.equals(ht.get("REG_ID"))||user_id.equals("000004")){%>
					<%if(!ht.get("FILE_NAME5").equals("")){%>
					<a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME5")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					<%}%>
						<%}%>
						<%if(ht.get("FILE5_YN").equals("Y")){%>����<%}%>
					</td>
					<td width='7%' align="center">
					<%if(user_id.equals(ht.get("REG_ID"))||user_id.equals("000004")){%>
					<%if(!ht.get("FILE_NAME6").equals("")){%>
					<a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME6")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					<%}%>
						<%}%>
						<%if(ht.get("FILE6_YN").equals("Y")){%>����<%}%>
					</td>
					<td width='7%' align="center">
					<%if(user_id.equals(ht.get("REG_ID"))||user_id.equals("000004")){%>
					<%if(!ht.get("FILE_NAME7").equals("")){%>
					<a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME7")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					<%}%>
						<%}%>
						<%if(ht.get("FILE7_YN").equals("Y")){%>����<%}%>
					</td>
					<td width='7%' align="center">
					<%if(user_id.equals(ht.get("REG_ID"))||user_id.equals("000004")){%>
					<%if(!ht.get("FILE_NAME8").equals("")){%>
					<a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME8")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					<%}%>
						<%}%>
						<%if(ht.get("FILE8_YN").equals("Y")){%>����<%}%>
					</td>
					<td width='7%' align="center">
					<%if(ht.get("CHANGE_HIS").equals("1")){%>
					���⵿��
					<%}else if(ht.get("CHANGE_HIS").equals("2")){%>
					�߰�
					<%}else if(ht.get("CHANGE_HIS").equals("2")){%>
					����
					<%}%>
					</td>
            	</tr>
<% }	%>
       	    
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>

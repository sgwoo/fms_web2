<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	document.domain = "amazoncar.co.kr";
	
	//����ϱ�
	function save(ment, mode){
		var fm = document.form1;	
		fm.mode.value = mode;
		
		//ķ���αݾ� ������ ������ �⵵, �б� ���� �޴´�. 
		
		if ( mode == '12' || mode == '13' || mode == '25' || mode == '26' || mode == '27'   || mode == '28'  || mode == '29' || mode == '30') {  //����/ä��/���/����ķ�������ޱݾ� 
			var SUBWIN="set_end_popup.jsp?mode="+mode+"&user_id="+fm.user_id.value+"&auth_rw="+fm.auth_rw.value;	
		 	window.open(SUBWIN, "set_end", "left=50, top=50, width=400, height=300, scrollbars=yes, status=yes");
		} else {
		
			if(!confirm(ment+'�� �����Ͻðڽ��ϱ�?'))
				return;
				
			fm.action = 'stat_end_null.jsp';
						
			if(mode == '9'){//���տ���ķ����
				fm.action = '/acar/stat_month/campaign2009_6_null.jsp';
			}
			
			if(mode == '15'){//�������ķ����
		//		fm.action = 'https://fms3.amazoncar.co.kr/fms2/mis/man_cost_campaign_null.jsp';
			}
			
			if(mode == '22'){//����ķ����
				fm.action = 'https://fms3.amazoncar.co.kr/fms2/mis/prop_campaign_null.jsp';
			}
			fm.target = 'i_no';
			
			
			fm.submit();	
		}		
	}	
	
	//����ϱ�
	function save2(ment, mode){
		var fm = document.form1;	
		fm.mode.value = mode;
		
		if(!confirm(ment+'�� �����Ͻðڽ��ϱ�?'))
			return;
						
		if(mode == '8'){//ä�Ǻ��ķ����						
			fm.action = '/acar/admin/stat_end_null_200911.jsp';
		}	
		
			 
		if(mode == '15'){//�������ķ����
		//	fm.action = 'https://fms3.amazoncar.co.kr/fms2/mis/man_cost_campaign_null.jsp';	
		}
		
		if(mode == '22'){//����ķ����
			fm.action = 'https://fms3.amazoncar.co.kr/fms2/mis/prop_campaign_null.jsp';	
		}
		
		fm.target = 'i_no';
		
			
		fm.submit();	
	}
	
	
	//����ϱ�
	function save1(ment, mode){
		var fm = document.form1;	
		fm.mode.value = mode;		
		//ķ���αݾ� ������ ������ �⵵, �б� ���� �޴´�. 
		
		if ( mode == '12' || mode == '13' || mode == '25' || mode == '26' || mode == '27'   || mode == '28'  || mode == '29' || mode == '30') {  //����/ä��/���/����ķ�������ޱݾ� 
			var SUBWIN="set_end_popup_file.jsp?mode="+mode+"&user_id="+fm.user_id.value+"&auth_rw="+fm.auth_rw.value;	
		 	window.open(SUBWIN, "set_end", "left=50, top=50, width=400, height=300, scrollbars=yes, status=yes");
		} 
					
	}	
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "11", "04", "01");


%>
<form action="stat_end_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=AddUtil.getDate()%>'>
<input type='hidden' name='mode' value=''>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td colspan=3>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>��������</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr> 
        <td colspan="3" align=right><img src=../images/center/arrow_gji.gif align=absmiddle> <font color="#666666"><b>: <%=AddUtil.getDate()%></b></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>    
    <tr> 
        <td>&nbsp;</td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ä ��Ȳ</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save2('��ä ��Ȳ','2');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>		
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_debt_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>	
    <tr>
        <td colspan=3></td>
    </tr>
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ��� ��Ȳ</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save2('�ڵ��� ��Ȳ','3');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_car_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr> 
        <td colspan="3">&nbsp;</td>
    </tr>	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� �뿩�� ��ü��Ȳ</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save2('�뿩�� ��ü ��Ȳ','1');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_dly_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td colspan=3></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� ����������Ȳ</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save2('����������Ȳ','5');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_mng_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td colspan=3></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� ����������Ȳ</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save2('����������Ȳ','6');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_bus_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td colspan=3></td>
    </tr>	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� �λ�������Ȳ</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save2('�λ�������Ȳ','7');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_total_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td colspan=3>�� ����� �λ�������Ȳ�� ä��ķ����+���������������Ȳ+���������������Ȳ�� �������Ǿ�� �����˴ϴ�.</td>
    </tr>	
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td style="background-color:666666 height=1"</td>
    </tr>	
    <tr>
        <td></td>
    </tr>

    <tr> 
        <td colspan="3">&nbsp;</td>
    </tr>
    <tr>
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>ä��ķ����</span></td>
        <td align="right"> 
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_settle_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td colspan=3></td>
    </tr>	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���տ���ķ����</span></td>
        <td align="right"> 
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_bus_cmp_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr> 
        <td colspan="3"> 
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������ķ����</span></td>
        <td align="right"> 
        </td>
    </tr>
       <tr> 
        <td colspan="2"><iframe src="stat_end_cost_list.jsp?gubun=m&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr> 
    <tr> 
        <td colspan="3"> 
        </td>
    </tr>   
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ķ����</span></td>
        <td align="right"> 
        </td>
    </tr>
       <tr> 
        <td colspan="2"><iframe src="stat_end_prop_list.jsp?gubun=p&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr> 
        <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="3"><hr></td>
    </tr>
	
    <tr> 
        <td colspan="3">&nbsp;</td>
    </tr>
    
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ķ�������ޱݾ�</span></td>
        <td align="right"> 
        <%if(nm_db.getWorkAuthUser("������",user_id)){%>
        <a href="javascript:save('����ķ��������','12');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>&nbsp;
        <a href="javascript:save1('����ķ��������','12');">���ϵ��</a>
        <%}%>
        </td>
    </tr>
    
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>ä��ķ�������ޱݾ�</span></td>
        <td align="right"> 
        <%if(nm_db.getWorkAuthUser("������",user_id)){%>
        <a href="javascript:save('ä��ķ��������','13');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>&nbsp;
        <a href="javascript:save1('ä��ķ��������','13');">���ϵ��</a>
        <%}%>
        </td>
    </tr>
    
    
      <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���(1��)ķ�������ޱݾ�</span></td>
        <td align="right"> 
        <%if(nm_db.getWorkAuthUser("������",user_id)){%>
        <a href="javascript:save('���(1��)ķ��������','30');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>&nbsp;
        <a href="javascript:save1('���(1��)ķ��������','30');">���ϵ��</a>
        <%}%>
        </td>
    </tr>
    
      <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���(2��)ķ�������ޱݾ�</span></td>
        <td align="right"> 
        <%if(nm_db.getWorkAuthUser("������",user_id)){%>
        <a href="javascript:save('���(2��)ķ��������','29');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>&nbsp;
        <a href="javascript:save1('���(2��)ķ��������','29');">���ϵ��</a>
        <%}%>
        </td>
    </tr>
    
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ķ�������ޱݾ�</span></td>
        <td align="right"> 
        <%if(nm_db.getWorkAuthUser("������",user_id)){%>
        <a href="javascript:save('����ķ��������','26');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>&nbsp;
        <a href="javascript:save1('����ķ��������','26');">���ϵ��</a>
        <%}%>
        </td>
    </tr>
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������б⸶��</span></td>
        <td align="right"> 
        <%if(nm_db.getWorkAuthUser("������",user_id)){%>
        <a href="javascript:save('��������б⸶��','27');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
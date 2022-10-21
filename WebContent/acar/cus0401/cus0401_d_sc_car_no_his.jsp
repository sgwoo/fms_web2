<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*" %>
<%@ page import="acar.cus0401.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String m_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");

	Cus0401_Database c_db = Cus0401_Database.getInstance();
 	Vector car_no_his = c_db.getCar_no_his(car_no);
		
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function mgr_addr(mgr_st){
	var fm = document.form1;
	window.open('/acar/car_rent/mgr_addr.jsp?auth_rw='+fm.auth_rw.value+'&m_id='+fm.m_id.value+'&l_cd='+fm.l_cd.value+'&mgr_st='+mgr_st, "MGR_ADDR", "left=100, top=100, width=650, height=170, scrollbars=yes");
}
/*��������������-------------------------------------------------------------------------------------------------------------*/

	//����: ���������� ����
	function select_mgr(idx, nm)
	{
		var fm = document.form1;
		fm.h_mgr_id_s.value 	= fm.h_mgr_id[idx].value;
		fm.t_mgr_st_s.value 	= nm;
		fm.t_mgr_dept_s.value 	= fm.t_mgr_dept[idx].value;
		fm.t_mgr_nm_s.value 	= fm.t_mgr_nm[idx].value;
		fm.t_mgr_title_s.value 	= fm.t_mgr_title[idx].value;
		fm.t_mgr_tel_s.value 	= fm.t_mgr_tel[idx].value;
		fm.t_mgr_mobile_s.value = fm.t_mgr_mobile[idx].value;
		fm.t_mgr_email_s.value 	= fm.t_mgr_email[idx].value;
	}
	
	//����: ���������� ����,�߰�
	function update_mgr(idx)
	{
		var fm = document.form1;
		if(fm.t_mgr_st_s.value == ''){					alert('���������� ���и��� �Է��Ͻʽÿ�');	return;	}
		else if(idx=='0' && fm.h_mgr_id_s.value!=''){	alert('�̹� ��ϵ� �����������Դϴ�');		return;	}
		else if(idx=='1' && fm.h_mgr_id_s.value==''){	alert('��ϵ��� ���� �����������Դϴ�');	return;	}
		else if(fm.h_mgr_id_s.value == '0' && fm.t_mgr_st_s.value != '�����̿���'){ alert('�����̿��� ���и��� ������ �� �����ϴ�'); return; }
		else if(fm.h_mgr_id_s.value == '1' && fm.t_mgr_st_s.value != '����������'){ alert('���������� ���и��� ������ �� �����ϴ�'); return; }
		else if(fm.h_mgr_id_s.value == '2' && fm.t_mgr_st_s.value != 'ȸ�������'){ alert('ȸ������� ���и��� ������ �� �����ϴ�'); return; }
		fm.mode.value = idx;
		fm.target='i_no';
		fm.action='./cus0401_d_sc_carmgr_iu.jsp';
		fm.submit();
	}		

/* Title ���� */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	}
	
	function init(){		
		setupEvents();
	}
//-->
</script>
</head>

<body onLoad="javascript:init()">
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type="hidden" name="l_cd" value="<%=l_cd%>">
<input type="hidden" name="mode" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>������ȣ�̷�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>

    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr id='tr_title' style='position:relative;z-index:1'> 
                    <td class="line">
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td class=line2 style='height:1'></td>
                            </tr>
                            <tr> 
                                <td class=title width="13%">������ȣ</td>
                                <td class=title width="18%">����</td>
                                <td class=title width="12%">���ʵ����</td>
                                <td class=title width="15%">����ȣ</td>
                                <td class=title width="18%">��ȣ</td>
                                <td class=title width="12%">������</td>
                                <td class=title width="12%">��������</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class="line">
                        <table width=100% border="0" cellspacing="1" cellpadding="0">
                        <%for(int i=0; i<car_no_his.size(); i++){
        				Hashtable ht = (Hashtable)car_no_his.elementAt(i);
        				String cls_st = (String)ht.get("CLS_ST"); %>
                            <tr> 
                                <td align='center' width="13%"><%= ht.get("CAR_NO")%></td>
                                <td width="18%">&nbsp;<%= ht.get("CAR_NAME")%></td>
                                <td align='center' width="12%"><%= AddUtil.ChangeDate2((String)ht.get("INIT_REG_DT"))%></td>
                                <td align='center' width="15%"><%= ht.get("RENT_L_CD")%></td>
                                <td align='center' width="18%"><%= ht.get("FIRM_NM")%></td>
                                <td align='center' width="12%"><%= AddUtil.ChangeDate2((String)ht.get("CLS_DT"))%></td>
                                <td align='center' width="12%"><% if(cls_st.equals("1")) out.println("��ุ��");
            							else if(cls_st.equals("2")) out.println("�ߵ��ؾ�");
            							else if(cls_st.equals("3")) out.println("�����Һ���");
            							else if(cls_st.equals("4")) out.println("��������");
            							else if(cls_st.equals("5")) out.println("�������");
            							else if(cls_st.equals("6")) out.println("�Ű�");
            							else if(cls_st.equals("7")) out.println("���������");
            							else if(cls_st.equals("8")) out.println("���Կɼ�");
            							else if(cls_st.equals("9")) out.println("����");
            							else out.println("(��)������"); %></td>
                            </tr>
                        <% } %>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>  
</table>
</form>
</body>
</html>

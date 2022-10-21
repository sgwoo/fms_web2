<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//��ȸ�ϱ�
	function search(){
		var fm = document.form1;	
		fm.target='d_content';
		fm.action='stat_dly_sc.jsp';		
		fm.submit();		
	}	
	
	//����ϱ�
	function save(){
		var fm = document.form1;	
		if(fm.dept_id.value != ''){ alert("�μ��� ��ü�� �����Ͻʽÿ�."); return; }
		var i_fm = i_view_l.form1;
		if(i_fm.save_dt.value != ''){ alert("�̹� ���� ��ϵ� �ڵ���������Ȳ�Դϴ�."); return; }
		if(!confirm('�����Ͻðڽ��ϱ�?'))
			return;
		i_fm.action = 'stat_dly_sc_null.jsp';		
		i_fm.target='i_no';	
		i_fm.submit();		
	}		
	
//-->
</script>
</head>

<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String search_kd = request.getParameter("search_kd")==null?"":request.getParameter("search_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");	
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	
	auth_rw = rs_db.getAuthRw(user_id, "01", "07", "02");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	long tot_dly_amt = 0;
	String tot_dly_per = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList(); //������ ����Ʈ ��ȸ
	int brch_size = branches.size();
	
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='search_kd' value='<%=search_kd%>'>
<input type='hidden' name='bus_id2' value='<%=bus_id2%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ä�ǰ��� > ��ü���� > <span class=style5>����� ��ü���� ��Ȳ</span></span></td>
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
                <tr> 
                    <td width="18%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_yus.gif align=absmiddle>&nbsp;
                        <select name='brch_id'>
                            <option value="" >��ü</option>			  
                            <%if(brch_size > 0){
            					for (int i = 0 ; i < brch_size ; i++){
            						Hashtable branch = (Hashtable)branches.elementAt(i);
            						%>
                            <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
                            <%= branch.get("BR_NM")%></option>
                            <%	}
            				}%>
                        </select>
                    </td>
                    <td width="13%"><img src=/acar/images/center/arrow_bs.gif align=absmiddle>&nbsp;
                        <select name='dept_id'>
                            <option value="" <%if(dept_id.equals(""))%>selected<%%>>��ü</option>
                            <option value="0001" <%if(dept_id.equals("0001"))%>selected<%%>>������</option>
                            <option value="0002"<%if(dept_id.equals("0002"))%>selected<%%>>������</option>
                            <option value="0004"<%if(dept_id.equals("0004"))%>selected<%%>>�� ��</option>
                            <option value="0007"<%if(dept_id.equals("0007"))%>selected<%%>>�λ�����</option>
                            <option value="0008"<%if(dept_id.equals("0008"))%>selected<%%>>��������</option>					
                        </select>
                    </td>
                    <td width="12%"><a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_search.gif align=absmiddle border=0></a></td>
                    <td align="right"><img src=../images/center/arrow_gji.gif align=absmiddle> :  
                        <input type='text' name='view_dt' size='11' value='<%if(save_dt.equals(""))%><%=AddUtil.getDate()%><%else%><%=AddUtil.ChangeDate2(save_dt)%>' class="whitetext" readonly>
                    </td>
                </tr>
            </table>
        </td>
        <td width="16">&nbsp;</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
              <%//��ü ��ü��
    			Vector feedps = ac_db.getFeeStat_Dlyper(brch_id, "", "", "", dept_id);
    			int feedp_size = feedps.size();
    			if(feedp_size > 0){
    				for (int i = 0 ; i < feedp_size ; i++){
    					IncomingSBean feedp = (IncomingSBean)feedps.elementAt(i);
    					tot_dly_amt = Long.parseLong(feedp.getTot_amt2());
    					tot_dly_per = feedp.getTot_su1();
    					%>
                <tr> 
                    <td class='title' width="12%">�Ѵ뿩��</td>
                    <td align="center" width="22%"><b><%=Util.parseDecimalLong(feedp.getTot_amt1())%>��</b>&nbsp;</td>
                    <td class='title' width="12%">��ü�뿩��</td>
                    <td align="center" width="21%"><b><font color='red'><%=Util.parseDecimal(feedp.getTot_amt2())%>��</font></b>&nbsp;<input type='hidden' name='tot_dly_amt' value='<%=Util.parseDecimal(feedp.getTot_amt2())%>'></td>
                    <td class='title' width="12%">��ü��</td>
                    <td align="center" width="21%"><b><font color='red'><%=feedp.getTot_su1()%>%</font></b>&nbsp;<input type='hidden' name='tot_dly_per' value='<%=feedp.getTot_su1()%>'></td>
                </tr>
              <%	}
    			}%>
            </table>
        </td>
        <td width="16" bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� ��ü ��Ȳ �׷���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=12% class="title">�����</TD>
                    <td width=11% class="title">��ü��</TD>
                    <td width=11% class="title">��ü������</TD>
                    <td>
                        <table width=100% border="0" cellspacing="0" cellpadding="0">
                            <tr align="right"> 
                                <td class="title_p" width="25%" style='text-align:right'>1</td>
                                <td class="title_p" width="25%" style='text-align:right'>2</td>
                                <td class="title_p" width="25%" style='text-align:right'>3</td>
                                <td class="title_p" width="25%" style='text-align:right'>4</td>
                            </tr>
                        </table>
                    </TD>
                </tr>
            </table>
        </td>
        <td width="16" bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="./stat_dly_sc_in_view_g.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch_id=<%=brch_id%>&dept_id=<%=dept_id%>&save_dt=<%=save_dt%>&tot_dly_amt=<%=tot_dly_amt%>&tot_dly_per=<%=tot_dly_per%>" name="i_view_g" width="100%" height="220" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� ��ü ��Ȳ ����Ʈ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="5%" class="title">&nbsp;&nbsp;����&nbsp;&nbsp;</td>
                    <td width="8%" class="title">�ٹ���</td>
                    <td width="8%" class="title">�μ�</td>
                    <td width="14%" class="title">�����</td>
                    <td width="13%" class="title">�Ѵ뿩��</td>
                    <td width="8%" class="title">��ü�Ǽ�</td>
                    <td width="12%" class="title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ü�뿩��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width="9%" class="title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ü��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width="9%" class="title">&nbsp;&nbsp;��ü������&nbsp;&nbsp;</td>
                    <td class="title" width="14%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
        <td width="16" bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="./stat_dly_sc_in_view_l.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch_id=<%=brch_id%>&dept_id=<%=dept_id%>&save_dt=<%=save_dt%>&tot_dly_amt=<%=tot_dly_amt%>" name="i_view_l" width="100%" height="190" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��Ȳ ����Ʈ</span></td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="./stat_dly_sc_in_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch_id=<%=brch_id%>&dept_id=<%=dept_id%>&save_dt=<%=save_dt%>&tot_dly_amt=<%=tot_dly_amt%>" name="i_list" width="100%" height="45" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><font color="#999999">�� ��ü�� : ������ ����ϴ� ����� �Ѵ뿩�ῡ 
        ���� ��ü�뿩�� ���� &nbsp;&nbsp;&nbsp;&nbsp;�� ��ü������ : �� ��ü�뿩�ῡ ���� ��� ��ü�뿩�� ���� 
        <a href="../bus_mng/bus_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>" target="_blank">.</a></font></td>
    </tr>	
</table>
</form>
</body>
</html>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.settle_acc.*, acar.user_mng.*"%>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
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
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_settle");
	
	long tot_dly_amt = 0;
	String tot_dly_per = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
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
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ������Ȳ > <span class=style5>����� �̼��� ��Ȳ</span></span></td>
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
                    <td width="18%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_yus.gif align=absmiddle>
                      &nbsp;<select name='brch_id'>
                        <option value="" <%if(brch_id.equals(""))%>selected<%%>>��ü</option>			  
                        <%if(brch_size > 0){
        					for (int i = 0 ; i < brch_size ; i++){
        						Hashtable branch = (Hashtable)branches.elementAt(i);
        						%>
                        <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID"))))%>selected<%%>> 
                        <%= branch.get("BR_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width="13%"><img src=../images/center/arrow_bs.gif align=absmiddle>
                      &nbsp;<select name='dept_id'>
                        <option value="" <%if(dept_id.equals(""))%>selected<%%>>��ü</option>
                        <option value="0001" <%if(dept_id.equals("0001"))%>selected<%%>>������</option>
                        <option value="0002"<%if(dept_id.equals("0002"))%>selected<%%>>������</option>
                        <option value="0004"<%if(dept_id.equals("0004"))%>selected<%%>>�� ��</option>	
                        <option value="0007"<%if(dept_id.equals("0007"))%>selected<%%>>�λ�����</option>
                        <option value="0008"<%if(dept_id.equals("0008"))%>selected<%%>>��������</option>				
                      </select>
                    </td>
                    <td width="15%"><a href='javascript:search()'><img src=../images/center/button_search.gif align=absmiddle border=0></a></td>
                    <td align="right"><img src=../images/center/arrow_gji.gif align=absmiddle> : 
                      <input type='text' name='view_dt' size='11' value='<%if(save_dt.equals(""))%><%=AddUtil.getDate()%><%else%><%=AddUtil.ChangeDate2(save_dt)%>' class="whitetext" readonly>
        			  <%if(nm_db.getWorkAuthUser("������",user_id)){%>
        			   &nbsp; 
                      <a href="javascript:save();"><img src=../images/center/button_mg.gif align=absmiddle border=0></a>
        			  <%}%>
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
			String total_amt = st_db.getStatSettleAmt("");
			String dly_amt = st_db.getStatSettleAmt("d");
			float dly_per = Float.parseFloat(dly_amt)/Float.parseFloat(total_amt)*100;
			%>
                <tr> 
                    <td class='title' width="12%">�ѹ�������</td>
                    <td align="center" width="22%"><b><%=Util.parseDecimalLong(total_amt)%>��</b>&nbsp;</td>
                    <td class='title' width="12%">��ü�ݾ�</td>
                    <td align="center" width="21%"><b><font color='red'><%=Util.parseDecimalLong(dly_amt)%>��</font></b>&nbsp;<input type='hidden' name='tot_dly_amt' value='<%=dly_amt%>'></td>
                    <td class='title' width="12%">��ü��</td>
                    <td align="center" width="21%"><b><font color='red'><%=AddUtil.parseFloatCipher(dly_per,2)%>%</font></b>&nbsp;<input type='hidden' name='tot_dly_per' value='<%=AddUtil.parseFloatCipher(dly_per,2)%>'></td>
                </tr>
          <%//	}
			//}%>
            </table>
        </td>
        <td width="16" bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� �̼�����Ȳ �׷���</span></td>
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
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
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
        <td colspan="2"><iframe src="./stat_settle_sc_in_view_g.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch_id=<%=brch_id%>&dept_id=<%=dept_id%>&save_dt=<%=save_dt%>&tot_dly_amt=<%=dly_amt%>&tot_dly_per=<%=AddUtil.parseFloatCipher(dly_per,2)%>" name="i_view_g" width="100%" height="220" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� �̼�����Ȳ ����Ʈ</span></td>
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
                    <td width="13%" class="title">�ѹ�������</td>
                    <td width="8%" class="title">��ü�Ǽ�</td>
                    <td width="12%" class="title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ü�ݾ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width="9%" class="title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ü��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width="9%" class="title">&nbsp;&nbsp;��ü������&nbsp;&nbsp;</td>
                    <td class="title" width="14%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
        <td width="16">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="./stat_settle_sc_in_view_l.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch_id=<%=brch_id%>&dept_id=<%=dept_id%>&save_dt=<%=save_dt%>&tot_dly_amt=<%=dly_amt%>&tot_dly_per=<%=AddUtil.parseFloatCipher(dly_per,2)%>" name="i_view_l" width="100%" height="190" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̼��� ����Ʈ</span></td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="./stat_settle_sc_in_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch_id=<%=brch_id%>&dept_id=<%=dept_id%>&save_dt=<%=save_dt%>&tot_dly_amt=<%=dly_amt%>&tot_dly_per=<%=AddUtil.parseFloatCipher(dly_per,2)%>" name="i_list" width="100%" height="45" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td height="19" colspan="2"><font color="#999999">�� ��ü�� : ������ ����ϴ� ����� �Ѵ뿩�ῡ 
        ���� ��ü�뿩�� ���� &nbsp;&nbsp;&nbsp;&nbsp;�� ��ü������ : �� ��ü�뿩�ῡ ���� ��� ��ü�뿩�� ���� 
        <a href="../bus_mng/bus_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>" target="_blank">.</a>
		<br>�� 2005��9��1�Ϻη� ���·�, ��å�� 5�� ���� ����</font></td>
    </tr>	
</table>
</form>
</body>
</html>

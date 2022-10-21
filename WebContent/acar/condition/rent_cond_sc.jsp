<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String gubun = request.getParameter("gubun")==null?"4":request.getParameter("gubun");	
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");	
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");	
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String g_fm = "1";
	String fn_id= "0";
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	String [] rcst = cdb.getRentCondSta_20071025(dt,ref_dt1,ref_dt2,gubun2, gubun3, gubun4);
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
	int cnt = 2+3; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
function CarRegList(rent_mng_id, rent_l_cd, car_mng_id, reg_gubun, rpt_no, firm_nm, client_nm, imm_amt)
{
	var theForm = document.CarRegDispForm;
	theForm.rent_mng_id.value = rent_mng_id;
	theForm.rent_l_cd.value = rent_l_cd;
	theForm.car_mng_id.value = car_mng_id;
	theForm.cmd.value = reg_gubun;
	theForm.rpt_no.value = rpt_no;
	theForm.firm_nm.value = firm_nm;
	theForm.client_nm.value = client_nm;
	theForm.imm_amt.value = imm_amt;
	
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		theForm.action = "./register_frame.jsp";
<%	}else{%>
		if(reg_gubun=="id"){	alert("�̵�� �����Դϴ�.");	return;	}
		theForm.action = "./register_frame.jsp";
<%	}%>
	theForm.target = "d_content"
	theForm.submit();
}

function view_cont(m_id, l_cd)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.mode.value = '2'; /*��ȸ*/
		fm.g_fm.value = '1';
		fm.action = '/fms2/lc_rent/lc_c_frame.jsp';
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form name='form1' method='post' target='d_content' action='/acar/car_rent/con_reg_frame.jsp'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='g_fm' value='1'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd'  value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>	
 <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
</form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td><iframe src="./rent_cond_sc_in.jsp?auth_rw=<%=auth_rw%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun2=<%= gubun2 %>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&sort=<%=sort%>" name="RegCondList" width="100%" height="<%=height - 80 %>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>		
    </tr>  
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td>
	        <table border=0 cellspacing=0 cellpadding=0 width=100%>
                <tr> 
                    <td width="40%">
			            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td class="line">
            				        <table border=0 cellspacing=1 width=100%>
            				            <tr>
			                                <td colspan=3 class=line2 style='height:1'></td>
			                            </tr>
                                        <tr> 
                                            <td colspan="3" class=title>��Ʈ</td>
                                        </tr>
                                        <tr> 
                                            <td class=title>�Ϲݽ�</td>
                                            <td class=title>�����</td>
                                            <td class=title>�⺻��</td>
                                        </tr>
                                        <tr> 
                                            <td align="right"><%=rcst[0]%> �� </td>
                                            <td align="right"><%=rcst[1]%> �� </td>
                                            <td align="right"><%=rcst[2]%> �� </td>
                                        </tr>
                                    </table>
            				    </td>
                                <td class="line">
            				        <table border=0 cellspacing=1 width=100%>
            				            <tr>
			                                <td colspan=3 class=line2 style='height:1'></td>
			                            </tr>
                                        <tr> 
                                            <td colspan="3" class=title>����</td>
                                        </tr>
                                        <tr> 
                                            <td class=title>�Ϲݽ�</td>
                                            <td class=title>�����</td>
                                            <td class=title>�⺻��</td>
                                        </tr>
                                        <tr> 
                                            <td align="right"><%=rcst[3]%> �� </td>
                                            <td align="right"><%=rcst[4]%> �� </td>
                                            <td align="right"><%=rcst[5]%> �� </td>
                                        </tr>
                                    </table>
            				    </td>
                            </tr>
                        </table>
                    </td>
                    <td width="30%">
            		    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td class="line">
            				        <table border=0 cellspacing=1 width=100%>
            				            <tr>
			                                <td colspan=5 class=line2 style='height:1'></td>
			                            </tr>
                                        <tr> 
                                            <td colspan="5" class=title>�뿩����</td>
                                        </tr>
                                        <tr> 
                                            <td class=title>48����</td>
                                            <td class=title>36����</td>
                                            <td class=title>24����</td>
                                            <td class=title>12����</td>
                                            <td class=title>��Ÿ</td>
                                        </tr>
                                        <tr> 
                                            <td align="right"><%=rcst[6]%> �� </td>
                                            <td align="right"><%=rcst[7]%> �� </td>
                                            <td align="right"><%=rcst[8]%> �� </td>
                                            <td align="right"><%=rcst[9]%> �� </td>
                                            <td align="right"><%=rcst[10]%> �� </td>
                                        </tr>
                                    </table>
            			        </td>
                            </tr>
                        </table>
                    </td>
                    <td width="30%">
            		    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td class="line">
            				        <table border=0 cellspacing=1 width=100%>
            				            <tr>
			                                <td colspan=3 class=line2 style='height:1'></td>
			                            </tr>
                                        <tr> 
                                            <td colspan="3" class=title>�뿩�ݾ�</td>
                                        </tr>
                                        <tr> 
                                            <td class=title>���ް�</td>
                                            <td class=title>�ΰ���</td>
                                            <td class=title>�հ�</td>
                                        </tr>
                                        <tr> 
                                            <td align="right"><%=Util.parseDecimal(rcst[11])%> ��</td>
                                            <td align="right"><%=Util.parseDecimal(rcst[12])%> ��</td>
                                            <td align="right"><%=Util.parseDecimal(rcst[13])%> ��</td>
                                        </tr>
                                    </table>
            				    </td>
                            </tr>
                        </table>
            	    </td>
                </tr>
            </table>
	    </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td>
	        <table border=0 cellspacing=0 cellpadding=0 width=100%>
                <tr> 
                    <td width="50%" valign=top>
			            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td class="line">
            				        <table border=0 cellspacing=1 width=100%>
            				            <tr>
			                                <td colspan=7 class=line2 style='height:1'></td>
			                            </tr>
                    				    <tr>
                    			            <td width="15%" class=title style='height:45'>�������</td>
                    			            <td width="15%" class=title>������Ʈ</td>
                    			            <td width="14%" class=title>������ü<br>�Ұ�</td>
                    			            <td width="14%" class=title>������ü</td>
                    			            <td width="14%" class=title>���ͳ�</td>
                    			            <td width="14%" class=title>catalog<br>�߼�</td>
                    			            <td width="14%" class=title>��ȭ���</td>
                    			        </tr>
                    			        <tr>
                    			            <td align="center"><%=rcst[15]%> �� </td>
                    			            <td align="center"><%=rcst[20]%> �� </td>
                    			            <td align="center"><%=rcst[16]%> �� </td>
                    			            <td align="center"><%=rcst[19]%> �� </td>
                    			            <td align="center"><%=rcst[14]%> �� </td>
                    			            <td align="center"><%=rcst[17]%> �� </td>
                    			            <td align="center"><%=rcst[18]%> �� </td>
                    			        </tr>
            			            </table>
            				    </td>
                            </tr>
                        </table>
		            </td>
                    <td width="50%">
		                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td class="line">
				                    <table border=0 cellspacing=1 width=100%>
				                        <tr>
			                                <td colspan=6 class=line2 style='height:1'></td>
			                            </tr>
			                            <tr>
                    			            <td width="15%" rowspan="2" class=title>����</td>
                    			            <td colspan="3" class=title>�縮��</td>
                    			            <td colspan="3" class=title>����</td>		  
		                                </tr>
			                            <tr>
                        			        <td width="15%" class=title>����</td>
                        		            <td width="14%" class=title>����</td>
                        			        <td width="14%" class=title>�ű�</td>
                        		            <td width="14%" class=title>����</td>
                        			        <td width="14%" class=title>����</td>
                        			        <td width="14%" class=title>�ű�</td>
			                            </tr>
			                            <tr>
                    			            <td align="center"><%=rcst[21]%> �� </td>					  
                    			            <td align="center"><%=rcst[27]%> �� </td>
                    			            <td align="center"><%=rcst[26]%> �� </td>					  
                    			            <td align="center"><%=rcst[25]%> �� </td>
                    			            <td align="center"><%=rcst[24]%> �� </td>
                    			            <td align="center"><%=rcst[23]%> �� </td>
                    			            <td align="center"><%=rcst[22]%> �� </td>
			                            </tr>
			                        </table>
				                </td>
                            </tr>
                        </table>
	                </td>
                </tr>
            </table>
	    </td>
    </tr> 
</table>
</body>
</html>
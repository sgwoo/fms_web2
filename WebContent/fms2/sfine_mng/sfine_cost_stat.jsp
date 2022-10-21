<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*,acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	
	//20191212 (��)���·�����Ȳ : t_forfeit_s_frame.jsp --> ��ü��. 
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	
	if(st_year.equals("") && st_mon.equals("") && gubun1.equals("")){
		st_year = AddUtil.getDate(1);
		st_mon = AddUtil.getDate(2);
		
		if(acar_de.equals("8888") ){
			gubun1 = ck_acar_id;
		}else{
			gubun1 = "000155";
		}
	}
	
	int year =AddUtil.getDate2(1);
	
	AddForfeitHanDatabase afm_db = AddForfeitHanDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector fines = afm_db.SFineCostStat(gubun1, st_year, st_mon);
	int fine_size = fines.size();
	
	int sum_num[] 	= new int[8];
	
%>
<html>
<head><title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.action ='sfine_cost_stat.jsp';
		fm.target = '_self';
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}

	//���·Ḯ��Ʈ����
	function view_list(reg_dt, st) {		
		//�ͽ��÷η� �Ķ���� ����
		window.open("sfine_cost_list.jsp?st_year=<%=st_year%>&st_mon=<%=st_mon%>&gubun1=<%=gubun1%>&gubun_reg_dt="+reg_dt+"&gubun_st="+st, "FINE_LIST", "left=10, top=10, width=1200, height=700 scrollbars=yes");		
	}	
	
	function ChangeWUser(w_nm){
		window.open("/fms2/menu/us_w_user_search.jsp?w_nm="+w_nm, "W_USER", "left=200, top=100, width=500, height=350, scrollbars=yes, status=yes, resizable=yes");
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='sfine_cost_stat.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>���·�����Ȳ</span></span></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='250'>&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;
						<select name="st_year">
							<%for(int i=2015; i<=year; i++){%>
							<option value="<%=i%>" <%if(AddUtil.parseInt(st_year) == i){%>selected<%}%>><%=i%>��</option>
							<%}%>
						</select> 
						<select name="st_mon">
							<option value="">��ü</option>
							<%for(int i=1; i<=12; i++){%>
							<option value="<%=AddUtil.addZero2(i)%>" <%if(AddUtil.parseInt(st_mon) == i){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
							<%}%>
						</select></td>
				    <td width='200'>&nbsp;&nbsp;<img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
						<select name="gubun1">
						    <%if(acar_de.equals("8888") ){%>
                            <option value="<%=ck_acar_id%>" selected><%=session_user_nm%></option>
						    <%}else{%>
						    <option value="" <%if(gubun1.equals("")){%>selected<%}%>>��ü��ȸ</option>
                            <option value="000155" <%if(gubun1.equals("000155")){%>selected<%}%>>������</option>
                            <option value="000107" <%if(gubun1.equals("000107")){%>selected<%}%>>�Ǽ���</option>                           
                            <%}%>							
                          </select>
                    </td>
                    <td>&nbsp;&nbsp;
                        <a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
					</td>
                </tr>
            </table>
        </td>
	</tr>  
	<tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	    
    <tr>
	    <td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td rowspan="2" colspan="1" class='title' width="20%"><p align="center">����</p></td>
					<td rowspan="1" colspan="2" class='title'><p align="center">������</p></td>
					<td rowspan="1" colspan="2" class='title'><p align="center">���ΰ���</p></td>
					<td rowspan="1" colspan="2" class='title'><p align="center">������(���Ͼ��ε�)</td>
					<td rowspan="2" colspan="1" class='title' width="13%"><p align="center">���ڹ������</td>
					<td rowspan="2" colspan="1" class='title' width="13%"><p align="center">�հ�<br>(������)</td>
				</tr>
				<tr>
					<td class='title' width="5%"><p align="center">�Ǽ�</p></td>
					<td class='title' width="13%"><p align="center">������</p></td>
					<td class='title' width="5%"><p align="center">�Ǽ�</p></td>
					<td class='title' width="13%"><p align="center">������</p></td>
					<td class='title' width="5%"><p align="center">�Ǽ�</p></td>
					<td class='title' width="13%"><p align="center">������</p></td>
				</tr>
				<%	for (int i = 0 ; i < fine_size ; i++){
						Hashtable ht = (Hashtable)fines.elementAt(i);
						int total = AddUtil.parseInt(String.valueOf(ht.get("AMT1")))+AddUtil.parseInt(String.valueOf(ht.get("AMT2")))+AddUtil.parseInt(String.valueOf(ht.get("AMT3")))+AddUtil.parseInt(String.valueOf(ht.get("AMT4")));
						sum_num[0] =  sum_num[0] + AddUtil.parseInt(String.valueOf(ht.get("CNT1")));
						sum_num[1] =  sum_num[1] + AddUtil.parseInt(String.valueOf(ht.get("AMT1")));
						sum_num[2] =  sum_num[2] + AddUtil.parseInt(String.valueOf(ht.get("CNT2")));
						sum_num[3] =  sum_num[3] + AddUtil.parseInt(String.valueOf(ht.get("AMT2")));
						sum_num[4] =  sum_num[4] + AddUtil.parseInt(String.valueOf(ht.get("CNT3")));
						sum_num[5] =  sum_num[5] + AddUtil.parseInt(String.valueOf(ht.get("AMT3")));						
				%> 
				<tr>
					<td align="center"><%=ht.get("T_REG_DT")%></td>
					<td align="right"><%if(st_mon.equals("")){%><%=AddUtil.parseDecimal(ht.get("CNT1"))%><%}else{%><a href="javascript:view_list('<%=ht.get("REG_DT")%>','1')"><%=AddUtil.parseDecimal(ht.get("CNT1"))%></a><%}%>��</td>
					<td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT1")))%>��</td>
					<td align="right"><%if(st_mon.equals("")){%><%=AddUtil.parseDecimal(ht.get("CNT2"))%><%}else{%><a href="javascript:view_list('<%=ht.get("REG_DT")%>','2')"><%=AddUtil.parseDecimal(ht.get("CNT2"))%></a><%}%>��</td>
					<td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT2")))%>��</td>
					<td align="right"><%if(st_mon.equals("")){%><%=AddUtil.parseDecimal(ht.get("CNT3"))%><%}else{%><a href="javascript:view_list('<%=ht.get("REG_DT")%>','3')"><%=AddUtil.parseDecimal(ht.get("CNT3"))%></a><%}%>��</td>
					<td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT3")))%>��</td>
					<td align="right"></td>
					<td align="right"><%=AddUtil.parseDecimal(total)%>��</td>
				</tr>				
				<%	} %>
				<%	int fine_edoc_amt = 0; 
					if(AddUtil.parseInt(st_year+""+st_mon) >= 202207){
						if(nm_db.getWorkAuthUser("���·����ڹ������",gubun1)){
							fine_edoc_amt = 970000; 
						}
					}	
				%>				
				<tr>
					<td class='title'>�հ�</td>
					<td align="right"><%=AddUtil.parseDecimal(sum_num[0])%>��</td>
					<td align="right"><%=AddUtil.parseDecimal(sum_num[1])%>��</td>
					<td align="right"><%=AddUtil.parseDecimal(sum_num[2])%>��</td>
					<td align="right"><%=AddUtil.parseDecimal(sum_num[3])%>��</td>
					<td align="right"><%=AddUtil.parseDecimal(sum_num[4])%>��</td>
					<td align="right"><%=AddUtil.parseDecimal(sum_num[5])%>��</td>
					<td align="right"><%=AddUtil.parseDecimal(fine_edoc_amt)%>��</td>
					<td align="right"><%=AddUtil.parseDecimal(sum_num[1]+sum_num[3]+sum_num[5]+fine_edoc_amt)%>��</td>
				</tr>		
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td>�� ������ �ܰ�ǥ </td>
	</tr>	
	<!--, (����� : ��Ͼ����� 2012-05-28�� ���� ��ϰ� 250��, ����ϰ� ����/�����۾� 2012-05-29�� ��Ϻ��� 350��. 20191201 ���� 400��) -->
	<tr>
		 <td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tbody>
					<tr>
						<td rowspan="1" colspan="2" class='title'><p>&nbsp;��    ��</p></td>
						<td class='title' width="18%"><p>������&nbsp;</p></td>
						<td class='title' width="18%"><p>���ΰ���</p></td>
						<td class='title' width="18%"><p>������(���Ͼ��ε�)</p></td>
						<td class='title'><p>���ڹ������&nbsp;</p></td>
					</tr>
					<tr>
						<td rowspan="2" class='title' width="10%"><p>&nbsp;�ܰ�</p></td>
						<td class='title' width="10%"><p>�ݾ�&nbsp;</p></td>
						<td align="center"><p>&nbsp;<%if(AddUtil.parseInt(st_year)>=2020 || AddUtil.parseInt(st_year+""+st_mon)>=201912){%>400��<%}else{%>350��<%}%></p></td>
						<td align="center"><p>&nbsp;150��</p></td>
						<td align="center"><p>&nbsp;100��</p></td>
						<td align="center"><p>&nbsp;��970,000��</p></td>
					</tr>
					<tr>
						<td class='title'><p>&nbsp;��������</p></td>
						<td align="center"><p>&nbsp;<%if(AddUtil.parseInt(st_year)>=2020 || AddUtil.parseInt(st_year+""+st_mon)>=201912){%>2019-12-01<%}else{%>2012-05-29<%}%></p></td>
						<td align="center"><p>&nbsp;2013-08-01</p></td>
						<td align="center"><p>&nbsp;2013-07-23</p></td>
						<td align="center"><p>&nbsp;2022-07-01</p></td>
					</tr>
					<tr>
						<td colspan="2" class='title'>��    Ÿ</td>
						<td colspan="4" >&nbsp;&nbsp;&nbsp;<!-- ���(�μ�)���� ���� -->
						���ڹ������(����24) ����� : <%=AddUtil.replace(c_db.getNameById(nm_db.getWorkAuthUser("���·����ڹ������"),"USER"),"(���·�)","") %>
						<a href="javascript:ChangeWUser('���·����ڹ������')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
						</td>
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>

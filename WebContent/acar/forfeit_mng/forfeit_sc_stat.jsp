<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.account.*, acar.forfeit_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//��ȭ �޸� ����
	function view_memo(m_id, l_cd, c_id, tm_st, accid_id, serv_id, mng_id){
		var auth_rw = document.form1.auth_rw.value;
		window.open("/acar/con_ins_m/ins_memo_frame_s.jsp?auth_rw="+auth_rw+"&tm_st="+tm_st+"&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&serv_id="+serv_id+"&mng_id="+mng_id, "INS_MEMO", "left=100, top=100, width=600, height=400");
	}	
	
	//���±� ���γ��� ����
	function view_forfeit(m_id, l_cd, c_id, seq_no){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.seq_no.value = seq_no;
		fm.target = "d_content";
//		fm.action = "/acar/forfeit_mng/forfeit_i_frame.jsp";
		fm.action = "/acar/fine_mng/fine_mng_frame.jsp";		
		fm.submit();
	}
	
	//���� ����
	function view_client(m_id, l_cd, r_st){
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
	
	//���� 
	function pop_excel(){
		var fm = i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("������ ����� ����� �����ϼ���.");
			return;
		}	
		fm.target = "_blak";
		fm.action = "popup_excel.jsp";
		fm.submit();
	}		

	//���
	function reg_forfeit(){
		var fm = document.form1;
		fm.target = "d_content";
//		fm.action = "/acar/forfeit_mng/forfeit_i_frame.jsp";
		fm.action = "/acar/fine_mng/fine_mng_frame.jsp";		
		fm.submit();
	}
	
	//���ݰ��� �̵�
	function forfeit_in(){
		var fm = document.form1;
		fm.gubun2.value = '6';
		fm.target = "d_content";
		fm.action = "/acar/con_forfeit/forfeit_frame_s.jsp";
		fm.submit();
	}	
	//��Ȳ
	function  view_stat(){
		var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=250px");
		document.form1.action="forfeit_sc_stat.jsp";
		document.form1.method="post";
		document.form1.target="Stat";
		document.form1.submit();
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"10":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

	if(user_id.equals("")){
		user_id=login.getCookieValue(request, "acar_id");
	}
	//�α���-�뿩����:����
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //��Ȳ ��� �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='serv_id' value=''>
<input type='hidden' name='seq_no' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='out'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;�繫ȸ�� > ���������� > <span class=style1><span class=style5>���·� ��Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>      		
        <td class='line'> 
            <table width="800" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" width=16% class='title' align="center">����</td>
                    <td colspan="2" class='title' align="center">���</td>
                    <td colspan="2" class='title' align="center">����</td>
                    <td colspan="2" class='title' align="center">��ü</td>
                    <td colspan="2" class='title' align="center">�հ�</td>
                </tr>
                <tr align="center"> 
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                </tr>
<%	//���·� ��Ȳ
	Vector fines = ac_db.getFineExpStat(br_id, "", "", "");
	int fine_size = fines.size();
	if(fine_size > 0){
		for (int i = 0 ; i < fine_size ; i++){
			IncomingSBean fine = (IncomingSBean)fines.elementAt(i);%>		
                <tr> 
                    <td align="center" class='title'><%=fine.getGubun()%></td>		
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_su1()%>%<% }else{%><%=fine.getTot_su1()%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt1())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_su2()%>%<% }else{%><%=fine.getTot_su2()%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt2())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_su3()%>%<% }else{%><%=fine.getTot_su3()%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt3())%>��<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(fine.getSt()==0){%><%=Integer.parseInt(fine.getTot_su2())+Integer.parseInt(fine.getTot_su3())%>��<%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                      <%if(fine.getSt()==0){%><%=Util.parseDecimal(Util.parseInt(fine.getTot_amt2())+Util.parseInt(fine.getTot_amt3()))%>��<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
<%		}
	}else{%>		
		        <tr>
			        <td colspan="10" align="center">�ڷᰡ �����ϴ�.</td>
		        </tr>
<%	}%>	
            </table>
        </td>
    </tr>	
    <tr>
	    <td align="right">
	        <a href="javascript:window.close();"><img src=../images/center/button_close.gif align=absmiddle border=0></a>
	    </td>
    </tr>  
</table>
</form>
</body>
</html>
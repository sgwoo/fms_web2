<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String maker = request.getParameter("maker")==null?"total":request.getParameter("maker");
	String gubun2 	= request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 5; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	if(height < 50) height = 150;
	
	//int start_year 	= 2007;				//ǥ�ý��۳⵵
	int end_year 	= AddUtil.getDate2(1);		//����⵵
	int start_year 	= end_year-10;					//ǥ�ý��۳⵵
 	int td_size 	= end_year-start_year+1;	//ǥ�ó⵵����
 	int td_width 	= 66/td_size;			//ǥ�ó⵵ ������ 
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
 	//��༭ ���� ����
	function view_cont(use_yn, m_id, l_cd, b_lst){
		var fm = document.form1;
		fm.use_yn.value = use_yn;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.mode.value = '2'; /*��ȸ*/
		fm.b_lst.value = b_lst;
		fm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15" rightmargin=0>
<form name="form1">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>
                    <td width="<%=s_width%>-220">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>
                      <% 		if(maker.equals("0001"))		out.print("�����ڵ���");
        						else if(maker.equals("0002"))	out.print("����ڵ���");
        						else if(maker.equals("0003"))	out.print("�����ڵ���");
        						else if(maker.equals("0004"))	out.print("�ѱ�GM");
        						else if(maker.equals("0005"))	out.print("�ֿ��ڵ���");
        						else if(maker.equals("0000"))	out.print("��Ÿ");
        						else 							out.print("��ü"); %>
                     </span></td>
                    <td align="right"><a href="stat_maker_car_sc.jsp?maker=<%=maker%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&sh_height=<%=sh_height%>"><img src=/acar/images/center/button_see_cjgbb.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>	
                </tr>
                <tr> 
                    <td colspan="2">
                        <table width="100%%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                          <td class="title" width="23%">����</td>
                                          <td class="title" width="<%=100-23-(td_width*td_size)%>%">�հ� </td>
										  <%for(int i = end_year ; i >= start_year ; i--){%>
										  <td class="title" width="<%=td_width%>%"><%=i%>��<%if(i==start_year){%>����<%}else{%>��<%}%></td>	
										  <%}%>
                                        </tr>
                                    </table>
                                </td>
                                <td width=17>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>								
                <tr> 
                    <td colspan="2"><iframe src="stat_maker_car_sc_in2.jsp?auth_rw=<%=auth_rw%>&maker=<%=maker%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                    </iframe></td>
                </tr>          
                <tr> 
                    <td colspan="2">
        			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td class="line">
                				    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                            <td width="23%" class="title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                            <td width="<%=100-23-(td_width*td_size)%>%" align="right"><input name="s_all" type="text"  class="whitenum" size="4" value="">&nbsp;&nbsp;</td>
											<%for(int i = end_year ; i >= start_year ; i--){//����⵵%>
                                            <td width="<%=td_width%>%" align="right"><input name="s<%=i%>" type="text"  class="whitenum" size="3" value="">&nbsp;&nbsp;</td> 
											<%}%>
                                        </tr>
                                    </table>
            				    </td>
            				    <td width=17>&nbsp;</td>
                            </tr>
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

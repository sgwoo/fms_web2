<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//�뿩�⺻����
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//�����ӽ�ȸ������Ʈ
	Vector vt = a_db.getCarCallInList(m_id, l_cd);
	int vt_size = vt.size();
	
	//����ȸ������
	int in_size 			= af_db.getYnCarCallIn(m_id, l_cd);

%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_callin(seq){
	 	var fm = document.form1;
		fm.seq.value = seq;
		fm.action = 'car_call_in.jsp';
		fm.target = 'callreg';		
		fm.submit();
  	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<body>

<form action='' method="post" name='form1'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='seq' value='<%=seq%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > <span class=style5>
						����ȸ������</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr> 
	<tr><td class=line2></td></tr>
    <tr>
	    <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>		    	
                <tr>
                    <td width='15%' class='title'>����ȣ</td>
                    <td width='20%'>&nbsp;
        			        <%=base.get("RENT_L_CD")%></td>
                    <td width='15%' class='title'>��ȣ</td>
                    <td width="50%">&nbsp;
        			        <%=base.get("FIRM_NM")%></td>
                </tr>
		      <%if(!String.valueOf(base.get("R_SITE")).equals("")){%>
                <tr>
                    <td class='title'>��뺻����</td>
                    <td colspan="3">&nbsp; <%=base.get("R_SITE")%></td>
                </tr>	
		      <%}%>	   
                <tr>
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;
        			        <font color="#000099"><b><%=base.get("CAR_NO")%></b></font></td>
                    <td class='title'>����</td>
                    <td>&nbsp;
			        <span title='<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>'><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span> </td>
                </tr>
                <tr>
                    <td class='title'> �뿩��� </td>
                    <td>&nbsp;
        			        <%=base.get("RENT_WAY")%></td>
                    <td class='title'>CMS</td>
                    <td>&nbsp;
        				      <%if(!cms.getCms_bank().equals("")){%>
							  <b>
								<%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%>
								</b>
        			 	      <%=cms.getCms_bank()%>:<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>~<%=AddUtil.ChangeDate2(cms.getCms_end_dt())%>(�ſ�<%=cms.getCms_day()%>��)
        			 	      <%}else{%>
        			      	-
        			 	      <%}%>
        	        </td>
                </tr>
                <tr>
                    <td class='title'>���������</td>
                    <td>&nbsp;
        			        <%=c_db.getNameById(String.valueOf(base.get("BUS_ID2")),"USER")%></td>
                    <td class='title'>���������</td>
                    <td>&nbsp;
        			        <%=c_db.getNameById(String.valueOf(base.get("MNG_ID")),"USER")%></td>
                </tr>		   
            </table>
	    </td>
    </tr>
    <tr>
	    <td align='right'>&nbsp;</td>
    </tr>
    <tr><td class=line2></td></tr>		
    <tr>
	    <td align='right' class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="6%" class='title'>����</td>
                    <td width="10%" class='title'>����</td>
                    <td width="15%" class='title'>ȸ������</td>
                    <td width="29%" class='title'>����</td>
                    <td width="15%" class='title'>�ε�/��������</td>					
                    <td width="15%" class='title'>�����</td>
                    <td width="10%" class='title'>�����</td>
                </tr>
<%		    for(int i = 0 ; i < vt_size ; i++){
			      Hashtable ht = (Hashtable)vt.elementAt(i);%>		  		
                 <tr align="center">
                    <td><%=i+1%></td>
                    <td><%if(String.valueOf(ht.get("IN_ST")).equals("1")){%>��ü
					    <%}else if(String.valueOf(ht.get("IN_ST")).equals("2")){%>����û
						<%}else if(String.valueOf(ht.get("IN_ST")).equals("3")){%>�����ݳ�
						<%}else if(String.valueOf(ht.get("IN_ST")).equals("4")){%>������ �������
						<%}%></td>
                    <td>
					<%if(nm_db.getWorkAuthUser("�����������",ck_acar_id) || nm_db.getWorkAuthUser("�����������ڵ�",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>
					<a href="javascript:view_callin('<%=ht.get("SEQ")%>')"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("IN_DT")))%></a>
					<%}else{%>
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("IN_DT")))%>
					<%}%>
					</td>
                    <td><%=ht.get("IN_CAU")%></td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("OUT_DT")))%></td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                    <td><%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%></td>					
                </tr>
<%		    }%>		
<%		    if(vt_size==0){%>		
		        <tr>
	  	            <td colspan='9' align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
    	        </tr>		
<%		    }%>		
            </table>
        </td>
    </tr>	
    <tr>
	    <td></td>
    </tr>
	<%if(nm_db.getWorkAuthUser("�����������",ck_acar_id) || nm_db.getWorkAuthUser("�����������ڵ�",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ȸ�� ���</span></td>
    </tr>
    <tr>
	    <td valign=top><iframe src="car_call_in.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&seq=<%=seq%>" name="callreg" width="100%" height="310" cellpadding="0" cellspacing="0" border="0" frameborder="0" topmargin=0 noresize></iframe></td>
    </tr>		
	<%}else{%>
	<%		if(in_size==0){%>


    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ȸ�� ���</span></td>
    </tr>
    <tr>
	    <td valign=top><iframe src="car_call_in.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&seq=<%=seq%>" name="callreg" width="100%" height="310" cellpadding="0" cellspacing="0" border="0" frameborder="0" topmargin=0 noresize></iframe></td>
    </tr>		
	<%		}else{%>	
    <tr>
	    <td>* �Ϸ�ó�� ���� ���� ȸ���� �ֽ��ϴ�. �Ϸ�ó���� ����� �� �ֽ��ϴ�.</td>
    </tr>	
	<%		}%>
	<%}%>
</table>
</form>
</body>
</html>

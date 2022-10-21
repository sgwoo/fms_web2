<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function AccidentDisp(m_id, l_cd, c_id, accid_id, accid_st){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.accid_id.value = accid_id;		
		fm.accid_st.value = accid_st;				
		fm.cmd.value = "u";		
		fm.submit();
	}
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	int size1 = 0;
	
	if(!st_dt.equals("")) 	st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) 	end_dt = AddUtil.replace(end_dt, "-", "");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
%>
<form name='form1' action='../accid_mng/accid_u_frame.jsp' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='accid_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='go_url' value='../accid_stat/accid_s_frame.jsp'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td>1. ������� ���ۻ纰 ���ĺ� ��Ȳ</td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        	<tr><td class=line2></td></tr>
          <tr> 
            <td class='title' width='150'>���ۻ�</td>
			<%for(int i=2000; i<=AddUtil.getDate2(1); i++){%>
            <td class='title'><%=i%>����</td>
			<%	size1++;
			}%>
            <td class='title' width="125">��</td>
          </tr>
		  	<%	Vector accids = as_db.getAccidStat01(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);
				int accid_size = accids.size();
				int su[] = new int[6];
				for (int i = 0 ; i < accid_size ; i++){
					Hashtable accid = (Hashtable)accids.elementAt(i);%>
          <tr> 
            <td class='title'><%=accid.get("NM")%></td>
            <td align="center"><%=accid.get("SU1")%>��</td>
            <td align="center"><%=accid.get("SU2")%>��</td>
            <td align="center"><%=accid.get("SU3")%>��</td>
            <td align="center"><%=accid.get("SU4")%>��</td>
            <td align="center"><%=accid.get("SU5")%>��</td>
            <td align="center"><%=accid.get("TOT_SU")%>��</td>
          </tr>
		<%			su[0]  = su[0]  + Integer.parseInt(String.valueOf(accid.get("SU1")));
			  		su[1]  = su[1]  + Integer.parseInt(String.valueOf(accid.get("SU2")));
			  		su[2]  = su[2]  + Integer.parseInt(String.valueOf(accid.get("SU3")));
			  		su[3]  = su[3]  + Integer.parseInt(String.valueOf(accid.get("SU4")));
		  			su[4]  = su[4]  + Integer.parseInt(String.valueOf(accid.get("SU5")));
			  		su[5]  = su[5]  + Integer.parseInt(String.valueOf(accid.get("TOT_SU")));
			  }%>		  
          <tr> 
            <td class='title'>��</td>
            <td align="center"><%=su[0]%>��</td>
            <td align="center"><%=su[1]%>��</td>
            <td align="center"><%=su[2]%>��</td>
            <td align="center"><%=su[3]%>��</td>
            <td align="center"><%=su[4]%>��</td>
            <td align="center"><%=su[5]%>��</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>2. ������ ������ ��Ȳ</td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width='100'>����</td>
		  	<%	Vector accids2 = as_db.getAccidStat02(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);
				int accid_size2 = accids2.size();
				int a=accid_size2;
				int listsize=6;
				if(a < listsize) listsize=a;
				for (int i = 0 ; i < listsize ; i++){
					Hashtable accid2 = (Hashtable)accids2.elementAt(i);%>			
            <td class='title'><%=accid2.get("CAR_NM")%></td>
			<%	}%>
            <td class='title' width="87">��Ÿ����</td>
            <td class='title' width="91">��</td>
          </tr>
          <tr> 
            <td class='title'>�Ǽ�</td>
			<%	int cnt1 = 0;
				for (int i = 0 ; i < listsize ; i++){
					Hashtable accid2 = (Hashtable)accids2.elementAt(i);%>				
            <td align="center"><%=accid2.get("TOT_SU")%>��</td>
			<%		cnt1  = cnt1  + Integer.parseInt(String.valueOf(accid2.get("TOT_SU")));
				}%>
            <td align="center"><%=su[5]-cnt1%>��</td>
            <td align="center"><%=su[5]%>��</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>3. ��������� ������ ��Ȳ</td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width='100'>�������</td>
            <td class='title' width='150'>�� �� ��</td>
            <td class='title' width="150">������</td>
            <td class='title' width="150">�����ܵ�</td>
            <td class='title' width="150">���뿭��</td>
            <td class='title' width="100">��</td>
          </tr>
          <tr> 
            <td class='title'>�Ǽ�</td>
		  	<%	Hashtable accid3 = as_db.getAccidStat03(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);%>
            <td align="center"><%=accid3.get("SU9")%>��</td>
            <td align="center"><%=accid3.get("SU10")%>��</td>
            <td align="center"><%=accid3.get("SU11")%>��</td>
            <td align="center"><%=accid3.get("SU12")%>��</td>
            <td align="center"><%=accid3.get("TOT_SU")%>��</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>4. ���� ������ ��Ȳ</td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width='100'>��</td>
            <td class='title' width='50'>1��</td>
            <td class='title' width="50">2��</td>
            <td class='title' width="50">3��</td>
            <td class='title' width="50">4��</td>
            <td class='title' width="50">5��</td>
            <td class='title' width="50">6��</td>
            <td class='title' width="50">7��</td>
            <td class='title' width="50">8��</td>
            <td class='title' width="50">9��</td>
            <td class='title' width="50">10��</td>
            <td class='title' width="50">11��</td>
            <td class='title' width="50">12��</td>
            <td class='title' width="100">��</td>
          </tr>
          <tr> 
            <td class='title'>�Ǽ�</td>
		  	<%	Hashtable accid4 = as_db.getAccidStat04(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);%>
            <td align="center"><%=accid4.get("SU1")%>��</td>
            <td align="center"><%=accid4.get("SU2")%>��</td>
            <td align="center"><%=accid4.get("SU3")%>��</td>
            <td align="center"><%=accid4.get("SU4")%>��</td>
            <td align="center"><%=accid4.get("SU5")%>��</td>
            <td align="center"><%=accid4.get("SU6")%>��</td>
            <td align="center"><%=accid4.get("SU7")%>��</td>
            <td align="center"><%=accid4.get("SU8")%>��</td>
            <td align="center"><%=accid4.get("SU9")%>��</td>
            <td align="center"><%=accid4.get("SU10")%>��</td>
            <td align="center"><%=accid4.get("SU11")%>��</td>
            <td align="center"><%=accid4.get("SU12")%>��</td>
            <td align="center"><%=accid4.get("TOT_SU")%>��</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>5. ���Ϻ� ������ ��Ȳ</td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width='100'>����</td>
            <td class='title' width='85'>��</td>
            <td class='title' width="85">ȭ</td>
            <td class='title' width="85">��</td>
            <td class='title' width="85">��</td>
            <td class='title' width="85">��</td>
            <td class='title' width="85">��</td>
            <td class='title' width="85">��</td>
            <td class='title' width="105">��</td>
          </tr>
          <tr> 
            <td class='title'>�Ǽ�</td>
		  	<%	Hashtable accid5 = as_db.getAccidStat05(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);%>
            <td align="center"><%=accid5.get("SU1")%>��</td>
            <td align="center"><%=accid5.get("SU2")%>��</td>
            <td align="center"><%=accid5.get("SU3")%>��</td>
            <td align="center"><%=accid5.get("SU4")%>��</td>
            <td align="center"><%=accid5.get("SU5")%>��</td>
            <td align="center"><%=accid5.get("SU6")%>��</td>
            <td align="center"><%=accid5.get("SU7")%>��</td>
            <td align="center"><%=accid5.get("TOT_SU")%>��</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>6. ��Һ� ������ ��Ȳ</td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width='100'>���</td>
            <td class='title' width='75'>���Ϸ�</td>
            <td class='title' width="75">������</td>
            <td class='title' width="75">ö��ǳθ�</td>
            <td class='title' width="75">Ŀ���</td>
            <td class='title' width="75">����</td>
            <td class='title' width="75">������</td>
            <td class='title' width="75">����</td>
            <td class='title' width="75">��Ÿ</td>
            <td class='title' width="100">��</td>
          </tr>
          <tr> 
            <td class='title'>�Ǽ�</td>
			<%	Hashtable accid6 = as_db.getAccidStat06(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);%>
            <td align="center"><%=accid6.get("SU1")%>��</td>
            <td align="center"><%=accid6.get("SU2")%>��</td>
            <td align="center"><%=accid6.get("SU3")%>��</td>
            <td align="center"><%=accid6.get("SU4")%>��</td>
            <td align="center"><%=accid6.get("SU5")%>��</td>
            <td align="center"><%=accid6.get("SU6")%>��</td>
            <td align="center"><%=accid6.get("SU7")%>��</td>
            <td align="center"><%=accid6.get("SU8")%>��</td>
            <td align="center"><%=accid6.get("TOT_SU")%>��</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>7. �������� �� ������Ǻ� ������ ��Ȳ</td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' rowspan="2" width='100'>����</td>
            <td class='title' colspan="3">��������</td>
            <td class='title' colspan="6">�������</td>
          </tr>
          <tr> 
            <td class='title' width="77">����</td>
            <td class='title' width="77">������</td>
            <td class='title' width="80">�Ұ�</td>
            <td class='title' width="77">����</td>
            <td class='title' width="77">�帲</td>
            <td class='title' width="77">��</td>
            <td class='title' width="77">�Ȱ�</td>
            <td class='title' width="77">��</td>
            <td class='title' width="81">�Ұ�</td>
          </tr>
          <tr> 
            <td class='title'>�Ǽ�</td>
			<%	Hashtable accid7 = as_db.getAccidStat07(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);%>
            <td align="center"><%=accid7.get("SU1")%>��</td>
            <td align="center"><%=accid7.get("SU2")%>��</td>
            <td align="center"><%=accid7.get("TOT_SU")%>��</td>
            <td align="center"><%=accid7.get("SU3")%>��</td>
            <td align="center"><%=accid7.get("SU4")%>��</td>
            <td align="center"><%=accid7.get("SU5")%>��</td>
            <td align="center"><%=accid7.get("SU6")%>��</td>
            <td align="center"><%=accid7.get("SU7")%>��</td>
            <td align="center"><%=accid7.get("TOT_SU")%>��</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
</body>
</html>

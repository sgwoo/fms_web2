<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function move_page_mng(st, gubun, idx){
		var fm = document.form1;

		fm.gubun1.value = '';
		fm.gubun2.value = '';
		fm.gubun3.value = '';
		fm.gubun4.value = '';
		fm.gubun5.value = '';
		fm.gubun6.value = '';
		
		if(st == 1){//���谡����Ȳ
			if(gubun == 'N'){			
											fm.gubun2.value = '5';
											fm.gubun3.value = '5';
				if     (idx   ==  1 ){		fm.gubun4.value = '1';									}
				else if(idx   ==  2 ){		fm.gubun4.value = '2';									}
				else if(idx   ==  3 ){		fm.gubun4.value = '3';									}
			}else{
				if(gubun == 'D'){			fm.gubun2.value = '1';									}
				else if(gubun == 'M'){		fm.gubun2.value = '2';									}
				if     (idx   ==  1 ){		fm.gubun3.value = '1';	fm.gubun4.value = '1';			}
				else if(idx   ==  2 ){		fm.gubun3.value = '1';	fm.gubun4.value = '2';			}
				else if(idx   ==  3 ){		fm.gubun3.value = '2';									}
				
				if(gubun == 'K'){						
					fm.gubun3.value = '8';
				}

			}
		}else if(st == 3){//������׺�����Ȳ
			if(gubun == 'D'){				fm.gubun2.value = '1';									}
			else if(gubun == 'M'){			fm.gubun2.value = '2';									}
											fm.gubun3.value = '3';
			if     (idx   ==  1 ){			fm.gubun4.value = '1';									}
			else if(idx   ==  2 ){			fm.gubun4.value = '2';									}
			else if(idx   ==  3 ){			fm.gubun4.value = '3';									}
			else if(idx   ==  4 ){			fm.gubun4.value = '4';									}
			else if(idx   ==  5 ){			fm.gubun4.value = '5';									}
		}else if(st == 4){//����������Ȳ
			if(gubun == 'N'){	
											fm.gubun2.value = '5';					
											fm.gubun3.value = '6';
				if     (idx   ==  1 ){		fm.gubun1.value = '1';	fm.gubun5.value = '1';			}
				else if(idx   ==  2 ){		fm.gubun1.value = '2';	fm.gubun5.value = '1';			}
			}else{			
				if(gubun == 'D'){			fm.gubun2.value = '1';									}
				else if(gubun == 'M'){		fm.gubun2.value = '2';									}
											fm.gubun3.value = '3';									
				if     (idx   ==  1 ){		fm.gubun1.value = '1';	fm.gubun5.value = '1';			}
				else if(idx   ==  2 ){		fm.gubun1.value = '2';	fm.gubun5.value = '1';			}
				else if(idx   ==  3 ){		fm.gubun1.value = '2';	fm.gubun5.value = '3';			}
				else if(idx   ==  4 ){		fm.gubun1.value = '2';	fm.gubun5.value = '2';			}				
			}
		}		
		fm.action = "../ins_mng/ins_s_frame.jsp";		
		fm.submit();
	}
	
	function move_page_amt(st, gubun, idx, idx2){
		var fm = document.form1;
		fm.gubun1.value = '';
		fm.gubun2.value = '';
		fm.gubun3.value = '';
		fm.gubun4.value = '';
		fm.gubun5.value = '';
		fm.gubun6.value = '';
		
		if(st == 2){//���Ժ����
													fm.gubun4.value = '0';
			if(gubun == 'D'){						fm.gubun2.value = '1';				}
			else if(gubun == 'M'){					fm.gubun2.value = '2';				}
			else if(gubun == 'N'){					fm.gubun3.value = '2';				}
			if(idx == '2' && gubun != 'N'){			fm.gubun3.value = '1';				}
			else if(idx == '3' && gubun != 'N'){	fm.gubun3.value = '0';				}

			if(idx2 == '1'){						fm.gubun5.value = '1';				}
			else if(idx2 == '2'){					fm.gubun5.value = '2';				}
			else if(idx2 == '3'){					fm.gubun5.value = '3';				}

		}else if(st == 5){//�����ȯ����Ȳ
													fm.gubun4.value = '2';		
			if(gubun == 'D'){						fm.gubun2.value = '1';				}
			else if(gubun == 'M'){					fm.gubun2.value = '2';				}
			else if(gubun == 'N'){					fm.gubun3.value = '2';				}
			if(idx == '2' && gubun != 'N'){			fm.gubun3.value = '1';				}
			else if(idx == '3' && gubun != 'N'){	fm.gubun3.value = '0';				}
		}
		fm.action = "../ins_mng2/ins_s_frame.jsp";		
		fm.submit();
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	InsDatabase ai_db = InsDatabase.getInstance();
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name="go_url" value=''>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='ins_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='mode' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > ������Ȳ > <span class=style5>������Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���谡����Ȳ</span></td>
    </tr>
    <%	Hashtable ins1 = ai_db.getInsStat1(1);%>
    <%	Hashtable ins2 = ai_db.getInsStat1(2);//�̰���%>
    <%	Hashtable ins13 = ai_db.getInsStat1(3);//��Ÿ%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td class='title' align="center" rowspan="2" width=20%>����</td>
                    <td class='title' colspan="2">���</td>
                    <td class='title' colspan="2">����</td>
                    <td class='title' align="center" width="20%">�̰���</td>
                    <td class='title' align="center" width="20%">�հ�(����+�̰���)</td>
                </tr>
                <tr align="center"> 
                    <td class='title' width=8%>�Ǽ�</td>
                    <td class='title' width=12%>�ݾ�</td>
                    <td class='title' width=8%>�Ǽ�</td>
                    <td class='title' width=12%>�ݾ�</td>
                    <td class='title'>�Ǽ�</td>
                    <td class='title'>�Ǽ�</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>����</td>
                    <td><a href="javascript:move_page_mng(1,'M',1)"><%=ins1.get("MC1")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins1.get("MA1")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(1,'D',1)"><%=ins1.get("DC1")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins1.get("DA1")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(1,'N',1)"><%=ins2.get("NC1")%>��</a></td>
                    <td><%=Util.parseInt(String.valueOf(ins2.get("NC1")))+Util.parseInt(String.valueOf(ins1.get("DC1")))%>��</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>�뵵����</td>
                    <td><a href="javascript:move_page_mng(1,'M',2)"><%=ins1.get("MC2")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins1.get("MA2")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(1,'D',2)"><%=ins1.get("DC2")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins1.get("DA2")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(1,'N',2)"><%=ins2.get("NC2")%>��</a></td>
                    <td><%=Util.parseInt(String.valueOf(ins2.get("NC2")))+Util.parseInt(String.valueOf(ins1.get("DC2")))%>��</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>����</td>
                    <td><a href="javascript:move_page_mng(1,'M',3)"><%=ins1.get("MC3")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins1.get("MA3")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(1,'D',3)"><%=ins1.get("DC3")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins1.get("DA3")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(1,'N',3)"><%=ins2.get("NC3")%>��</a></td>
                    <td><%=Util.parseInt(String.valueOf(ins2.get("NC3")))+Util.parseInt(String.valueOf(ins1.get("DC3")))%>��</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>�հ�</td>
                    <td><a href="javascript:move_page_mng(1,'M',4)"><%=Util.parseInt(String.valueOf(ins1.get("MC1")))+Util.parseInt(String.valueOf(ins1.get("MC2")))+Util.parseInt(String.valueOf(ins1.get("MC3")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins1.get("MA1")))+Util.parseInt(String.valueOf(ins1.get("MA2")))+Util.parseInt(String.valueOf(ins1.get("MA3"))))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(1,'D',4)"><%=Util.parseInt(String.valueOf(ins1.get("DC1")))+Util.parseInt(String.valueOf(ins1.get("DC2")))+Util.parseInt(String.valueOf(ins1.get("DC3")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins1.get("DA1")))+Util.parseInt(String.valueOf(ins1.get("DA2")))+Util.parseInt(String.valueOf(ins1.get("DA3"))))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(1,'N',4)"><%=Util.parseInt(String.valueOf(ins2.get("NC1")))+Util.parseInt(String.valueOf(ins2.get("NC2")))+Util.parseInt(String.valueOf(ins2.get("NC3")))%>��</a></td>
                    <td><%=Util.parseInt(String.valueOf(ins2.get("NC1")))+Util.parseInt(String.valueOf(ins2.get("NC2")))+Util.parseInt(String.valueOf(ins2.get("NC3")))+Util.parseInt(String.valueOf(ins1.get("DC1")))+Util.parseInt(String.valueOf(ins1.get("DC2")))+Util.parseInt(String.valueOf(ins1.get("DC3")))%>��</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>��Ÿ</td>
                    <td></td>
                    <td align="right"></td>
                    <td></a></td>
                    <td align="right"></td>
                    <td><a href="javascript:move_page_mng(1,'K',0)"><%if(ins13.size()>0){%><%=ins13.get("KCOUNT")%>��<%}else{%>0��<%}%></a></td>
                    <td></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Ժ����</span></td>
    </tr>
    <%	Hashtable ins3 = ai_db.getInsStat2(1);%>
    <%	Hashtable ins4 = ai_db.getInsStat2(2);%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class='title' align="center" rowspan="2" colspan="2">����</td>
                    <td class='title' align="center" colspan="2" height="19">���</td>
                    <td class='title' align="center" colspan="2" height="19">����</td>
                    <td class='title' align="center" colspan="2" height="19">���ϰ��</td>
                    <td colspan="2" class='title' align="center" height="19">�հ�(����+���ϰ��)</td>
                </tr>
                <tr align="center"> 
                    <td class='title' width="8%">�Ǽ�</td>
                    <td class='title' width="12%">�ݾ�</td>
                    <td class='title' width="8%">�Ǽ�</td>
                    <td class='title' width="12%">�ݾ�</td>
                    <td class='title' width="8%">�Ǽ�</td>
                    <td class='title' width="12%">�ݾ�</td>
                    <td class='title' width="8%">�Ǽ�</td>
                    <td class='title' width="12%">�ݾ�</td>
                </tr>
                <tr align="center"> 
                    <td class='title' rowspan="3" width=10%>��ȹ</td>
                    <td class='title' width=10%>����</td>
                    <td><a href="javascript:move_page_amt(2,'M',1,1)"><%=Util.parseInt(String.valueOf(ins3.get("MC1")))+Util.parseInt(String.valueOf(ins3.get("MC4")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("MA1")))+Util.parseInt(String.valueOf(ins3.get("MA4"))))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'D',1,1)"><%=Util.parseInt(String.valueOf(ins3.get("DC1")))+Util.parseInt(String.valueOf(ins3.get("DC4")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA1")))+Util.parseInt(String.valueOf(ins3.get("DA4"))))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'N',1,1)"><%=Util.parseInt(String.valueOf(ins4.get("NC1")))+Util.parseInt(String.valueOf(ins4.get("NC4")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins4.get("NA1")))+Util.parseInt(String.valueOf(ins4.get("NA4"))))%>��&nbsp;</td>
                    <td><%=Util.parseInt(String.valueOf(ins3.get("DC1")))+Util.parseInt(String.valueOf(ins3.get("DC4")))+Util.parseInt(String.valueOf(ins4.get("NC1")))+Util.parseInt(String.valueOf(ins4.get("NC4")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA1")))+Util.parseInt(String.valueOf(ins3.get("DA4")))+Util.parseInt(String.valueOf(ins4.get("NA1")))+Util.parseInt(String.valueOf(ins4.get("NA4"))))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>�뵵����</td>
                    <td><a href="javascript:move_page_amt(2,'M',1,2)"><%=Util.parseInt(String.valueOf(ins3.get("MC2")))+Util.parseInt(String.valueOf(ins3.get("MC5")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("MA2")))+Util.parseInt(String.valueOf(ins3.get("MA5"))))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'D',1,2)"><%=Util.parseInt(String.valueOf(ins3.get("DC2")))+Util.parseInt(String.valueOf(ins3.get("DC5")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA2")))+Util.parseInt(String.valueOf(ins3.get("DA5"))))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'N',1,2)"><%=Util.parseInt(String.valueOf(ins4.get("NC2")))+Util.parseInt(String.valueOf(ins4.get("NC5")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins4.get("NA2")))+Util.parseInt(String.valueOf(ins4.get("NA5"))))%>��&nbsp;</td>
                    <td><%=Util.parseInt(String.valueOf(ins3.get("DC2")))+Util.parseInt(String.valueOf(ins3.get("DC5")))+Util.parseInt(String.valueOf(ins4.get("NC2")))+Util.parseInt(String.valueOf(ins4.get("NC5")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA2")))+Util.parseInt(String.valueOf(ins3.get("DA5")))+Util.parseInt(String.valueOf(ins4.get("NA2")))+Util.parseInt(String.valueOf(ins4.get("NA5"))))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>����</td>
                    <td><a href="javascript:move_page_amt(2,'M',1,3)"><%=Util.parseInt(String.valueOf(ins3.get("MC3")))+Util.parseInt(String.valueOf(ins3.get("MC6")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("MA3")))+Util.parseInt(String.valueOf(ins3.get("MA6"))))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'D',1,3)"><%=Util.parseInt(String.valueOf(ins3.get("DC3")))+Util.parseInt(String.valueOf(ins3.get("DC6")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA3")))+Util.parseInt(String.valueOf(ins3.get("DA6"))))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'N',1,3)"><%=Util.parseInt(String.valueOf(ins4.get("NC3")))+Util.parseInt(String.valueOf(ins4.get("NC6")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins4.get("NA3")))+Util.parseInt(String.valueOf(ins4.get("NA6"))))%>��&nbsp;</td>
                    <td><%=Util.parseInt(String.valueOf(ins3.get("DC3")))+Util.parseInt(String.valueOf(ins3.get("DC6")))+Util.parseInt(String.valueOf(ins4.get("NC3")))+Util.parseInt(String.valueOf(ins4.get("NC6")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA3")))+Util.parseInt(String.valueOf(ins3.get("DA6")))+Util.parseInt(String.valueOf(ins4.get("NA3")))+Util.parseInt(String.valueOf(ins4.get("NA6"))))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title' rowspan="3">����</td>
                    <td class='title'>����</td>
                    <td><a href="javascript:move_page_amt(2,'M',2,1)"><%=ins3.get("MC1")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("MA1")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'D',2,1)"><%=ins3.get("DC1")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("DA1")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'N',2,1)"><%=ins4.get("NC1")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins4.get("NA1")))%>��&nbsp;</td>
                    <td><%=Util.parseInt(String.valueOf(ins3.get("DC1")))+Util.parseInt(String.valueOf(ins4.get("NC1")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA1")))+Util.parseInt(String.valueOf(ins4.get("NA1"))))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>�뵵����</td>
                    <td><a href="javascript:move_page_amt(2,'M',2,2)"><%=ins3.get("MC2")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("MA2")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'D',2,2)"><%=ins3.get("DC2")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("DA2")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'N',2,2)"><%=ins4.get("NC2")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins4.get("NA2")))%>��&nbsp;</td>
                    <td><%=Util.parseInt(String.valueOf(ins3.get("DC2")))+Util.parseInt(String.valueOf(ins4.get("NC2")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA2")))+Util.parseInt(String.valueOf(ins4.get("NA2"))))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>����</td>
                    <td><a href="javascript:move_page_amt(2,'M',2,3)"><%=ins3.get("MC3")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("MA3")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'D',2,3)"><%=ins3.get("DC3")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("DA3")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'N',2,3)"><%=ins4.get("NC3")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins4.get("NA3")))%>��&nbsp;</td>
                    <td><%=Util.parseInt(String.valueOf(ins3.get("DC3")))+Util.parseInt(String.valueOf(ins4.get("NC3")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA3")))+Util.parseInt(String.valueOf(ins4.get("NA3"))))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title' rowspan="3">�ܾ�</td>
                    <td class='title'>����</td>
                    <td><a href="javascript:move_page_amt(2,'M',3,1)"><%=ins3.get("MC4")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("MA4")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'D',3,1)"><%=ins3.get("DC4")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("DA4")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'N',3,1)"><%=ins4.get("NC4")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins4.get("NA4")))%>��&nbsp;</td>
                    <td><%=Util.parseInt(String.valueOf(ins3.get("DC4")))+Util.parseInt(String.valueOf(ins4.get("NC4")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA4")))+Util.parseInt(String.valueOf(ins4.get("NA4"))))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>�뵵����</td>
                    <td><a href="javascript:move_page_amt(2,'M',3,2)"><%=ins3.get("MC5")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("MA5")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'D',3,2)"><%=ins3.get("DC5")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("DA5")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'N',3,2)"><%=ins4.get("NC5")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins4.get("NA5")))%>��&nbsp;</td>
                    <td><%=Util.parseInt(String.valueOf(ins3.get("DC5")))+Util.parseInt(String.valueOf(ins4.get("NC5")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA5")))+Util.parseInt(String.valueOf(ins4.get("NA5"))))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>����</td>
                    <td><a href="javascript:move_page_amt(2,'M',3,3)"><%=ins3.get("MC6")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("MA6")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'D',3,3)"><%=ins3.get("DC6")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("DA6")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(2,'N',3,3)"><%=ins4.get("NC6")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins4.get("NA6")))%>��&nbsp;</td>
                    <td><%=Util.parseInt(String.valueOf(ins3.get("DC6")))+Util.parseInt(String.valueOf(ins4.get("NC6")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA6")))+Util.parseInt(String.valueOf(ins4.get("NA6"))))%>��&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>������׺�����Ȳ</span></td>
    </tr>
    <%	Hashtable ins5 = ai_db.getInsStat3(1);%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class='title' align="center" rowspan="2" colspan="2">����</td>
                    <td class='title' align="center" colspan="2" height="19">���</td>
                    <td class='title' align="center" colspan="2" height="19">����</td>
                </tr>
                <tr align="center"> 
                    <td class='title' width=10%>�Ǽ�</td>
                    <td class='title' width=14%>�ݾ�</td>
                    <td class='title' width=10%>�Ǽ�</td>
                    <td class='title' width=14%>�ݾ�</td>
                </tr>
                <tr align="center"> 
                    <td class='title' rowspan="2" width=16%>�뵵����</td>
                    <td class='title' width=16%>R-&gt;L</td>
                    <td><a href="javascript:move_page_mng(3,'M',1)"><%=ins5.get("MC1")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins5.get("MA1")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(3,'D',1)"><%=ins5.get("DC1")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins5.get("DA1")))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>L-&gt;R</td>
                    <td><a href="javascript:move_page_mng(3,'M',2)"><%=ins5.get("MC2")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins5.get("MA2")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(3,'D',2)"><%=ins5.get("DC2")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins5.get("DA2")))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title' colspan="2">�Ű�</td>
                    <td><a href="javascript:move_page_mng(3,'M',3)"><%=ins5.get("MC3")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins5.get("MA3")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(3,'D',3)"><%=ins5.get("DC3")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins5.get("DA3")))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title' colspan="2">����</td>
                    <td><a href="javascript:move_page_mng(3,'M',5)"><%=ins5.get("MC5")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins5.get("MA5")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(3,'D',5)"><%=ins5.get("DC5")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins5.get("DA5")))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title' colspan="2">����</td>
                    <td><a href="javascript:move_page_mng(3,'M',4)"><%=ins5.get("MC4")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins5.get("MA4")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(3,'D',4)"><%=ins5.get("DC4")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins5.get("DA4")))%>��&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td><font color="#999999">�� ������ : ���������߻�����</font></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����������Ȳ</span></td>
    </tr>
    <%	Hashtable ins6 = ai_db.getInsStat4(1);%>
    <%	Hashtable ins7 = ai_db.getInsStat4(2);%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class='title' align="center" rowspan="2" colspan="2">����</td>
                    <td class='title' align="center" colspan="2">���</td>
                    <td class='title' align="center" colspan="2">����</td>
                    <td class='title' align="center" width="20%">������</td>
                    <td width="20%" class='title' align="center">�հ�(����+������)</td>
                </tr>
                <tr align="center"> 
                    <td class='title' width=8%>�Ǽ�</td>
                    <td class='title' width=12%>�ݾ�</td>
                    <td class='title' width=8%>�Ǽ�</td>
                    <td class='title' width=12%>�ݾ�</td>
                    <td class='title'>�Ǽ�</td>
                    <td class='title'>�Ǽ�</td>
                </tr>
                <tr align="center"> 
                    <td class='title' width=10%>��Ʈ</td>
                    <td class='title' width=10%>���պ���</td>
                    <td><a href="javascript:move_page_mng(4,'M',1)"><%=ins6.get("MC1")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins6.get("MA1")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(4,'D',1)"><%=ins6.get("DC1")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins6.get("DA1")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(4,'N',1)"><%=Util.parseInt(String.valueOf(ins7.get("NC1")))+Util.parseInt(String.valueOf(ins7.get("NC3")))%>��</a></td>
                    <td><%=Util.parseInt(String.valueOf(ins6.get("DC1")))+Util.parseInt(String.valueOf(ins7.get("NC1")))+Util.parseInt(String.valueOf(ins7.get("NC3")))%>��</td>
                </tr>
                <tr align="center"> 
                    <td class='title' rowspan="4">����</td>
                    <td class='title'>���պ���</td>
                    <td><a href="javascript:move_page_mng(4,'M',2)"><%=ins6.get("MC2")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins6.get("MA2")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(4,'D',2)"><%=ins6.get("DC2")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins6.get("DA2")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(4,'N',2)"><%=Util.parseInt(String.valueOf(ins7.get("NC2")))+Util.parseInt(String.valueOf(ins7.get("NC4")))%>��</a></td>
                    <td><%=Util.parseInt(String.valueOf(ins6.get("DC2")))+Util.parseInt(String.valueOf(ins7.get("NC2")))+Util.parseInt(String.valueOf(ins7.get("NC4")))%>��</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>���Ǻ���</td>
                    <td><a href="javascript:move_page_mng(4,'M',3)"><%=ins6.get("MC3")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins6.get("MA3")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(4,'D',3)"><%=ins6.get("DC3")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins6.get("DA3")))%>��&nbsp;</td>
                    <td>-</td>
                    <td><%=ins6.get("DC3")%>��</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>å�Ӻ���</td>
                    <td><a href="javascript:move_page_mng(4,'M',4)"><%=ins6.get("MC4")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins6.get("MA4")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(4,'D',4)"><%=ins6.get("DC4")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins6.get("DA4")))%>��&nbsp;</td>
                    <td>-</td>
                    <td><%=ins6.get("DC4")%>��</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>�Ұ�</td>
                    <td><a href="javascript:move_page_mng(4,'M',5)"><%=Util.parseInt(String.valueOf(ins6.get("MC2")))+Util.parseInt(String.valueOf(ins6.get("MC3")))+Util.parseInt(String.valueOf(ins6.get("MC4")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins6.get("MA2")))+Util.parseInt(String.valueOf(ins6.get("MA3")))+Util.parseInt(String.valueOf(ins6.get("MA4"))))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_mng(4,'D',5)"><%=Util.parseInt(String.valueOf(ins6.get("DC2")))+Util.parseInt(String.valueOf(ins6.get("DC3")))+Util.parseInt(String.valueOf(ins6.get("DC4")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins6.get("DA2")))+Util.parseInt(String.valueOf(ins6.get("DA3")))+Util.parseInt(String.valueOf(ins6.get("DA4"))))%>��&nbsp;</td>
                    <td>-</td>
                    <td><%=Util.parseInt(String.valueOf(ins6.get("DC2")))+Util.parseInt(String.valueOf(ins6.get("DC3")))+Util.parseInt(String.valueOf(ins6.get("DC4")))%>��</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td><font color="#999999">�� ������ : û������</font></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����ȯ����Ȳ</span></td>
    </tr>
    <%	Hashtable ins8 = ai_db.getInsStat5(1);%>
    <%	Hashtable ins9 = ai_db.getInsStat5(2);%>
    <%	Hashtable ins10 = ai_db.getInsStat5(3);%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class='title' align="center" rowspan="2" width=20%>����</td>
                    <td class='title' align="center" colspan="2" height="19">���</td>
                    <td class='title' align="center" colspan="2" height="19">����</td>
                    <td class='title' align="center" colspan="2" height="19">��ü</td>
                    <td colspan="2" class='title' align="center" height="19">�հ�(����+��ü)</td>
                </tr>
                <tr align="center"> 
                    <td class='title' width=8%>�Ǽ�</td>
                    <td class='title' width=12%>�ݾ�</td>
                    <td class='title' width=8%>�Ǽ�</td>
                    <td class='title' width=12%>�ݾ�</td>
                    <td class='title' width=8%>�Ǽ�</td>
                    <td class='title' width=12%>�ݾ�</td>
                    <td class='title' width=8%>�Ǽ�</td>
                    <td class='title' width=12%>�ݾ�</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>��ȹ</td>
                    <td><a href="javascript:move_page_amt(5,'M',1,0)"><%=Util.parseInt(String.valueOf(ins8.get("MC1")))+Util.parseInt(String.valueOf(ins8.get("MC2")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins8.get("MA1")))+Util.parseInt(String.valueOf(ins8.get("MA2"))))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(5,'D',1,0)"><%=Util.parseInt(String.valueOf(ins9.get("DC1")))+Util.parseInt(String.valueOf(ins9.get("DC2")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins9.get("DA1")))+Util.parseInt(String.valueOf(ins9.get("DA2"))))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(5,'N',1,0)"><%=Util.parseInt(String.valueOf(ins10.get("NC1")))+Util.parseInt(String.valueOf(ins10.get("NC2")))%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins10.get("NA1")))+Util.parseInt(String.valueOf(ins10.get("NA2"))))%>��&nbsp;</td>
                    <td><%=Util.parseInt(String.valueOf(ins9.get("DC1")))+Util.parseInt(String.valueOf(ins9.get("DC2")))+Util.parseInt(String.valueOf(ins10.get("NC1")))+Util.parseInt(String.valueOf(ins10.get("NC2")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins9.get("DA1")))+Util.parseInt(String.valueOf(ins9.get("DA2")))+Util.parseInt(String.valueOf(ins10.get("NA1")))+Util.parseInt(String.valueOf(ins10.get("NA2"))))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>����</td>
                    <td><a href="javascript:move_page_amt(5,'M',2,0)"><%=ins8.get("MC1")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins8.get("MA1")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(5,'D',2,0)"><%=ins9.get("DC1")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins9.get("DA1")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(5,'N',2,0)"><%=ins10.get("NC1")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins10.get("NA1")))%>��&nbsp;</td>
                    <td><%=Util.parseInt(String.valueOf(ins9.get("DC1")))+Util.parseInt(String.valueOf(ins10.get("NC1")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins9.get("DA1")))+Util.parseInt(String.valueOf(ins10.get("NA1"))))%>��&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>�̼���</td>
                    <td><a href="javascript:move_page_amt(5,'M',3,0)"><%=ins8.get("MC2")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins8.get("MA2")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(5,'D',3,0)"><%=ins9.get("DC2")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins9.get("DA2")))%>��&nbsp;</td>
                    <td><a href="javascript:move_page_amt(5,'N',3,0)"><%=ins10.get("NC2")%>��</a></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ins10.get("NA2")))%>��&nbsp;</td>
                    <td><%=Util.parseInt(String.valueOf(ins9.get("DC1")))+Util.parseInt(String.valueOf(ins10.get("NC2")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins9.get("DA1")))+Util.parseInt(String.valueOf(ins10.get("NA2"))))%>��&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td><font color="#999999">�� ��ü : û���Ϸ� ���� 5�� ����� ���</font></td>
    </tr>
</table>  
</form>
</body>
</html>

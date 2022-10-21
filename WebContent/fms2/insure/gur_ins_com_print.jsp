<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.user_mng.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")		==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String chk[] 	= request.getParameterValues("chk");	

	int sh_height = request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String gi_no = "";
	String firm_nm = "";
	String client_nm = "";
	String ssn = "";
	String enp_no = "";
	String gi_amt = "";
	
	String gi_start_dt = "";
	String gi_end_dt = "";
	String rent_start_dt = "";
	String rent_end_dt = "";

	String user_nm = "";
	String hot_tel = "";
	String dept_nm = "";
	
%>


<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<style>
/* @font-face { font-family: 'oACYCZno'; src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_eight@1.0/oACYCZno.woff') format('woff'); font-weight: normal; font-style: normal; } */
@import url('https://cdn.rawgit.com/moonspam/NanumSquare/master/nanumsquare.css');
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    background-color: #ddd;
}
* {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
}
.paper {
    width: 210mm;
    padding-top: 10mm; /* set contents area */
    padding-left: 10mm; /* set contents area */
    padding-right: 10mm; /* set contents area */
     margin-top: 10mm;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}
.content {
    padding: 0px;
   /*  border: 1px #888 solid ; */
}
@page {
    size: A4;
    margin: 0;
}
@media print {
    html, body {
        width: 210mm;
       
        background: #fff;
    }
    .paper {
        margin: 0;
        border: initial;
        border-radius: initial;
        width: initial;
        min-height: initial;
        box-shadow: initial;
        background: initial;
        page-break-after: always;
    }
   
}
	/* #contents {font-size:9pt}; */
 table {
     border: 0.5px solid #444444;
    border-collapse: collapse; 
  }
  th, td {
    border: 0.5px solid #444444;
    font-size:11pt;
    text-align:center;
  }
  td{
  
  }
  input[type="text"]{font-family: 'NanumSquare', sans-serif;border:0px;margin:0px;padding:0px;width:200px;}
.title{font-size:11.5pt;font-weight:bold;}  
.contents {font-size:11.5pt; /* font-family:����; */ }
.contents tr{ height:30px;}
/* #wrap { font-family: 'oACYCZno', sans-serif;} */
#wrap { font-family: 'NanumSquare', sans-serif;}

 #hrTable{
 	background-color:black; 
}	
#hrTable td{
	 border-style:solid; 
	border-left-width:2px;
	border-color:white;
}

</style>
</head>
<body leftmargin="" topmargin="1" >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<form action="" name="form1" method="POST" >
	<script>
	</script>
	
<%
	
	for(int i = 0 ; i < chk.length ; i++){
		s_kd = "2";
		t_wd = chk[i];
		
		Vector vt = a_db.getGuaInsureList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5);
		int vt_size = vt.size();
	
		for(int j = 0 ; j < 1 ; j++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(j);
			gi_no = String.valueOf(ht.get("GI_NO"));
			firm_nm = String.valueOf(ht.get("FIRM_NM"));
			client_nm = String.valueOf(ht.get("CLIENT_NM"));
			ssn = String.valueOf(ht.get("SSN"));
			enp_no = String.valueOf(ht.get("ENP_NO"));
			gi_amt = String.valueOf(ht.get("GI_AMT"));
		
			gi_start_dt = String.valueOf(ht.get("GI_START_DT"));
			gi_end_dt = String.valueOf(ht.get("GI_END_DT"));
			rent_start_dt = String.valueOf(ht.get("RENT_START_DT"));
			rent_end_dt = String.valueOf(ht.get("RENT_END_DT"));
		}
		
		UsersBean mng_user 	= umd.getUsersBean(ck_acar_id);
		user_nm = mng_user.getUser_nm();
		hot_tel = mng_user.getHot_tel();
		dept_nm = mng_user.getDept_nm(); 

%>
    <div class="paper">
    <div class="content">
		<div id="wrap" style="width:100%;">
			<div>
				<div style="margin-top:50px;margin-bottom:8px;font-size:9pt">(10��02��005, 2017.07.24)</div>
				<table border="0" cellspacing="0" cellpadding='0' width='100%' align="center" class="contents">
					<tr style="margin:10px;">
						<td width=82%" style="text-align:left;margin-bottom:15px;padding:7px 5px;font-size:18pt;font-weight:bold">&nbsp;&nbsp;����Ϸ�(����ä���Ҹ�)&nbsp;&nbsp;Ȯ�μ�</td>
						<td width="18%"><img src=/acar/images/center/gur_ins_logo.jpg width=120></td>
						
					</tr>
				</table>
			
			
			</div>
			<br>
			<div style="margin-top:4px;">
				<div style="margin-bottom:10px;font-weight:bold;font-size:12pt">&nbsp;<span>��</span>&nbsp;&nbsp;����������&nbsp;&nbsp;��&nbsp;&nbsp;�ְ�೻��&nbsp;</div> 
				<table border="0" cellspacing="0" cellpadding='0' width='100%' align="center" class="contents" style="table-layout:;">
					<tr>
						<td class="title" style="padding:8.5px 0px;"><span style="letter-spacing:35px;">���ǹ�</span>ȣ</td>
						<td colspan="3" style="text-align:left;">&nbsp;&nbsp;<input type="text" style="font-size:11pt;" value=<%=gi_no %>></td>		
					</tr>
					<tr>
						<td class="title"style="padding:8.5px 0px"><span style="letter-spacing:35px;">�����</span>ǰ</td>
						<td colspan="3" style="text-align:left;">&nbsp;&nbsp;<input type="text" style="font-size:11pt;" value="����(����)��������"></td>
					</tr>
					<tr>
						<td class="title" style="padding:8.5px 0px" width="25%"><span style="letter-spacing:22px;">������</span>��</td>
						<%if(firm_nm.equals(client_nm)){ %>
						<td width="25%" style="text-align:left;">&nbsp;&nbsp;<%=firm_nm %></td>		
						<td class="title" width="18%"><span style="letter-spacing:2px;">����(�����</span>)<br>
							<span style="letter-spacing:17px;">��Ϲ�</span>ȣ</td>		
						<td style="text-align:left;">&nbsp;&nbsp;<%=ssn %></td>		
						<%}else{ %>
						<td width="25%" style="text-align:left;">&nbsp;&nbsp;<%=firm_nm %><br>&nbsp;&nbsp;<%=client_nm %></td>		
						<td class="title" width="18%"><span style="letter-spacing:5px;">����(�����</span>)<br>
							<span style="letter-spacing:18px;">��Ϲ�</span>ȣ</td>		
						<td style="text-align:left;">&nbsp;&nbsp;<input type="text" style=" font-size:11pt;" value=<%=enp_no %>><br>&nbsp;&nbsp;<input type="text" style=" font-size:11pt;" value=<%=ssn %>></td>		
						<%} %>
					</tr>
					<tr style="">	
						<td class="title" style="padding:8.5px 0px "><span style="letter-spacing:15px;">���谡�Ա�</span>��</td>
						<td style="text-align:left;">&nbsp;&nbsp;<%=Util.parseDecimal(gi_amt)%>&nbsp;��&nbsp;</td>
						
						<td class="title" width="18%"><span style="letter-spacing:17px;">�����</span>��</td>		
						<td style="text-align:left;">&nbsp;&nbsp;<input type="text" style="font-size:11pt;width:80px;" value=<%=AddUtil.ChangeDate(gi_start_dt,"YYYY-MM-DD")%>>~
						&nbsp;&nbsp;<input type="text" style="font-size:11pt;width:80px;" value=<%=AddUtil.ChangeDate(gi_end_dt,"YYYY-MM-DD")%>></td>
						
					</tr>
				</table>
			</div>			
			<div style="margin-top:0px;">
				<table border="0" cellspacing="0" cellpadding='0' width='100%' align="center" class="contents" style="table-layout:;">
					<tr>
						<td class="title" style="padding:8.5px 0px"><span style="letter-spacing:35px;">�ְ��</span>��</td>
						<td colspan="3" style="text-align:left;">&nbsp;&nbsp;<input type="text" style="font-size:11pt;" value="�ڵ����뿩�̿���"></td>		
					</tr>
					<tr>
						<td class="title"  width="25%" style="padding:8.5px 0px"><span style="letter-spacing:35px;">����</span>��</td>
						<td style="text-align:left;" width="25%">&nbsp;&nbsp;<%=Util.parseDecimal(gi_amt)%>&nbsp;��&nbsp;</td>		
						<td class="title" width="18%"><span style="letter-spacing:17px;">����</span>��</td>		
						<td style="text-align:left;">&nbsp;&nbsp;<input type="text" style="font-size:11pt;width:80px;" value=<%=AddUtil.ChangeDate(rent_start_dt,"YYYY-MM-DD")%>>~
						&nbsp;&nbsp;<input type="text" style="font-size:11pt;width:80px;" value=<%=AddUtil.ChangeDate(rent_end_dt,"YYYY-MM-DD")%>></td>
					</tr>
				</table>
			</div>			
			<br>
			<div style="margin-top:3px;">
				<div style="margin-bottom:9px;font-weight:bold;font-size:12pt;">
					&nbsp;<span>��</span>&nbsp;&nbsp;Ȯ�λ���&nbsp;
					<span style="font-size:9.5pt;font-weight:normal;word-spacing:2px;">
						&nbsp;&nbsp;&nbsp;��<span style="text-decoration: underline;font-weight:bold">�ش��ϴ� ������ üũ(<img src=/acar/images/center/check_icon.png width="10" height="9">)</span>�Ͻð�, "�ְ�ǻ� ä������Ϸ���" �Ǵ�  "����ä���Ҹ���"�� �����Ͽ� �ֽʽÿ�.
					</span>
				</div> 
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents" style="table-layout:fixed;">
					<tr style="border-bottom:2px dotted darkgray;">
						<td>
							<div style="font-size:11pt;margin:17 5px;text-align:left;word-spacing:3px;">
								<div style="margin-bottom:3px;">&nbsp; �Ǻ����� ������ ��� ����������� �����Ͽ�, �Ʒ��� ���� ������ �߻������ν�, <b>"������������ ȿ��"��</b></div>
								<div><b>&nbsp;"���ﺸ������(��)�� ����ä�� ���� ����å��"�� (</b><span> <input type="text" style="font-size:10.5pt;width:100px;" value=<%=AddUtil.ChangeDate(rent_end_dt,"YYYY-MM-DD")%>></span> )<b>�ڷ� ������ �Ҹ��Ͽ����� Ȯ��</b>�մϴ�.</div>
							</div>
						</td>
					</tr>
					<tr>
						<td class="">
							<div style="font-size:11pt;margin:22 8px;text-align:left;word-spacing:3px;">
								<div style="margin-bottom:8px;">&nbsp;<b>��<input type="checkbox" checked>�������ڰ� �ְ��� ä���� ������ �����Ͽ���</b></div>
								<div style="margin-bottom:3px;">&nbsp;<b>�� �������ڰ� �ְ��� ä���� ������ ���������� �ʾ�����, �Ʒ��� ���� ������ �߻��Ͽ���</b></div>
								<div style="margin-left:37px;"><input type="checkbox">�������������� �ٸ� �㺸(Ÿ��� ������, �ε��� �㺸 ��)�� ��ü��</div>
								<div style="margin-left:37px;"><input type="checkbox">�㺸�� ���� �ʰ�, �ſ�ŷ��� ��ȯ��<span style="margin-right:26px;"></span> <input type="checkbox">��Ÿ���� :</div>
							</div>
						
						</td>
					</tr>
				</table>
			</div>			
			<br>
			<div style="margin-bottom:0px;height:28px;">
				<div style="height:30px;width:200px;float:left;font-weight:bold;font-size:12pt;padding-top:5px;">
					&nbsp;<span>��</span>&nbsp;&nbsp;Ȯ����(�Ǻ�����)&nbsp;
				</div>
				<div style="height:30px;width:200px;border:0.5px solid black;border-radius:3px;float:right;font-size:9pt;padding-top:9px;padding-right:4px;text-align:right;">
					<span style="letter-spacing:15px;"><input type="text" style="width:45px;text-align:right;margin-right:5px;">��<input type="text" style="width:25px;text-align:right;margin-right:5px;">��</span>
					<input type="text" style="width:25px;text-align:right;margin-right:5px;">��
				</div>
			</div>
			<div style="margin-top:3px;">
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents">
					<tr>
						<td class="title" width="17%" style="padding:10px 0px"><span style="letter-spacing:5px;">��ȣ/��ǥ</span>��</td>
						<td style="text-align:left;font-size:14pt;">
							<span style="margin-right:45px;">&nbsp;(��)�Ƹ���ī</span>	
							<span style="word-spacing:22px;">��ǥ�̻� ������ <span style="font-size:9pt;">(��)</span></span>
						</td>		
					</tr>
					<tr>
						<td class="title" style="padding:10px 0px"><span style="letter-spacing:70px;">��</span>��</td>
						<td style="text-align:left;font-size:14pt;">&nbsp;<span>����Ư���� �������� �ǻ���� 8 802ȣ</span>
						</td>
					</tr>
				</table>
			</div>			
				<div style="margin-top:0px;">
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents">
					<tr>
						<td class="title" width="17%" style="padding:10px 0px"><span style="letter-spacing:29px;">���</span>��</td>
						<td class="title"width="30%"  style="text-align:left;">&nbsp;&nbsp;<span style="letter-spacing:10px;"><%=user_nm %></span></td>		
						<td class="title" width="17%"><span style="letter-spacing:70px;">��</span>��	
						<td width="%"></td>		
					</tr>
					<tr>
						<td class="title" style="padding:10px 0px"><span style="letter-spacing:15px;">����</span>��</td>
						<td class="title"width="30%"  style="text-align:left;">&nbsp;&nbsp;<span style="letter-spacing:10px;"><%=dept_nm %></span></td>
						<td class="title"><span style="letter-spacing:27px;">����</span>ó</td>	
						<td class="title"width=""  style="text-align:left;">&nbsp;&nbsp;<span style=""><%=hot_tel %></span></td>
					</tr>
				</table>
			</div>			
			<br>
			<div style="margin-top:0px;">
				<div style="margin-bottom:10px;font-weight:bold;font-size:12pt;">&nbsp;���ﺸ������ �ֽ�ȸ�� ����&nbsp;</div> 
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents" style="table-layout:fixed;">
					<tr>
						<td class="">
							<div style="font-size:8.5pt;margin:7 7px;text-align:left;">
								<div style="margin-bottom:3px;">�غ������ڴԲ� �˷��帳�ϴ�.</div>
								<div style="margin-bottom:3px;">�ְ����� ä��(�ǹ�)�� ����Ⱓ �߿� ������ �����Ͽ��� ���� �Ǻ����ڷκ��� �� Ȯ�μ��� Ȯ�ι޴� ��쿡�� �������� ���� ȯ�޹����� ����ᰡ</div>
								<div style="margin-bottom:3px;">���� �� �ֽ��ϴ�. 'ȯ�ް����� ����ᰡ �ִ��� ����' �� 'ȯ������' � ���ؼ��� �� Ȯ�μ��� ���������� �����Ͻ� �� �ȳ������ñ� �ٶ��ϴ�.</div>
							</div>
						</td>
					</tr>
				</table>
			</div>			
			<br>
		
			<div style="margin-top:3px;">
				<table id="hrTable" border="0" cellspacing="0" cellpadding='0' width='98%' style="height:3px;">
					<tr>
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
					</tr>
				</table>
			</div>
			<div style="margin-top:14px;"align="right">
				<table border="0" cellspacing="0" cellpadding='0' width='76%' height='76' class="contents" style="table-layout:fixed;">
					<tr>
						<td width="6%" style="font-size:9pt;">
							<div>ȸ<br>��<br>��<br>��<br>��</div>
						</td>
						<td>
							<div style="font-size:9pt; position: relative;top:-24; text-align:left;color:lightgray;font-style:italic">
								<span>&nbsp;Ȯ���Ͻ� �� ����</span>
							</div>
						</td>
					</tr>
				</table>
			</div>	
			<br>
	</div>
	</div>
	</div>
	<%} %>
</form>
</body>
</head>
</html>
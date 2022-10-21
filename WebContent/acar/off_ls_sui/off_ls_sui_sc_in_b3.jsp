<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_sui.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	Offls_suiBean detail = olsD.getSui_detail(car_mng_id);
	String imgfile[] = new String[5];
	imgfile[0] = detail.getImgfile1();
	imgfile[1] = detail.getImgfile2();
	imgfile[2] = detail.getImgfile3();
	imgfile[3] = detail.getImgfile4();
	imgfile[4] = detail.getImgfile5();
	

	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();

	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//��ǰ�� ���� ��� �����ϱ� ����
	String apprsl_car_mng_id = olsD.getApprsl_Car_mng_id(car_mng_id);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<style>
a:link { text-decoration:none; }
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
var imgnum =0;
carImage = new Array();
for(i=0; i<5; i++){
	carImage[i] = new Image();
}
carImage[0].src = "https://fms3.amazoncar.co.kr/images/carImg/<%=imgfile[0]%>.gif";
carImage[1].src = "https://fms3.amazoncar.co.kr/images/carImg/<%=imgfile[1]%>.gif";
carImage[2].src = "https://fms3.amazoncar.co.kr/images/carImg/<%=imgfile[2]%>.gif";
carImage[3].src = "https://fms3.amazoncar.co.kr/images/carImg/<%=imgfile[3]%>.gif";
carImage[4].src = "https://fms3.amazoncar.co.kr/images/carImg/<%=imgfile[4]%>.gif";

function show(n){
	document.images["carImg"].src = carImage[n].src;
	document.form1.carImg.value = carImage[n].src;
	imgnum = n;
}
function ChDate(arg)
{
	var ch_date = replaceString("-","",arg);

	if(ch_date!="")
	{
	if(ch_date.length!=8)
	{
		alert('��¥�� ������ "2002-01-23" �Ǵ� "200020123" �Դϴ�.');
		return "";
	}
	ch_year = parseInt(ch_date.substring(0,4),10);
	ch_month = parseInt(ch_date.substring(4,6),10);
	ch_day = parseInt(ch_date.substring(6,8),10);
	if(isNaN(ch_date))
	{
		alert("���ڿ� '-' ���� �Է°����մϴ�.");
		return "";
	}
	if(!(ch_month>0 && ch_month<13))
	{
		alert("���� 01 - 12 ������ �Է� �����մϴ�.");
		return "";
	}
	ck_day = getDaysInMonth(ch_year,ChangeNum(ch_month))
	if(ck_day<ch_day)
	{
		alert("���� 01 - " + ck_day + " ������ �Է� �����մϴ�.");
		return "";
	}
		
	return ch_year + ""+ChangeNum(ch_month) + ChangeNum(ch_day);
	}else{
	return "";
	}
}
function apprslUpd(ioru)
{
	var fm = document.form1;	
	var apprsl_dt = ChDate(fm.apprsl_dt.value);
	if(apprsl_dt != ""){
		fm.apprsl_dt_s.value = apprsl_dt;
	}else{
		alert("�����ڸ� �Է��ϼ���!");
		return;
	}
	if(ioru=="i"){
		if(!confirm('�򰡳����� ����Ͻðڽ��ϱ�?')){ return; }
	}else if(ioru=="u"){
		if(!confirm('�򰡳����� �����Ͻðڽ��ϱ�?')){ return; }
	}
	fm.gubun.value = ioru;
	fm.action="/acar/off_lease/off_lease_apprsl_upd.jsp";
	fm.target = "i_no";
	fm.submit();
}
function open_car_mng()
{
	var url = "?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
	var SUBWIN = "/acar/off_lease/off_lease_car_mng.jsp"+url;
	window.open(SUBWIN, "View_CAR_MNG", "left=70, top=80, width=735, height=400, resizable=yes, scrollbars=yes");
}
function open_car_his()
{
	var url = "?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
	var SUBWIN = "/acar/off_lease/off_lease_car_his.jsp"+url;
	window.open(SUBWIN, "View_CAR_HIS", "left=70, top=80, width=550, height=400, resizable=yes, scrollbars=yes");
}
function open_accident()
{
	var url = "?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&car_no=<%=detail.getCar_no()%>&car_nm=<%=detail.getCar_nm()%>";
	var SUBWIN = "/acar/off_lease/off_lease_accident.jsp"+url;
	window.open(SUBWIN, "View_ACCIDENT", "left=70, top=80, width=835, height=400, resizable=yes, scrollbars=yes");
}
function imgAppend(){
	<%
	int num = 0;
	for(int i=0; i<imgfile.length; i++){
		if(!imgfile[i].equals("")){
			num++;
		}
	}
	if(num==5){%>
		alert("5�������� �߰��˴ϴ�.!");
		return;
	<%}else{%>
		window.open("/acar/off_lease/off_lease_imgAppend.jsp?car_mng_id=<%=car_mng_id%>&imgfile1=<%=detail.getImgfile1()%>&imgfile2=<%=detail.getImgfile2()%>&imgfile3=<%=detail.getImgfile3()%>&imgfile4=<%=detail.getImgfile4()%>&imgfile5=<%=detail.getImgfile5()%>&imgnum=<%= num %>", "imgAppend", "left=300, top=200, width=400, height=100, resizable=no, scorllbars=no");
	<%}%>
}
function imgDelete(){
	var imgName = "";
	if(imgnum==0){ imgName = "����"; }
	else if(imgnum==1){ imgName = "�ǳ�"; }
	else if(imgnum==2){ imgName = "��"; }
	else if(imgnum==3){ imgName = "����"; }
	else if(imgnum==4){ imgName = "��";}

	if(!confirm(imgName+' �̹����� �����Ͻðڽ��ϱ�?')){ return; }
	var fm = document.form1;
	fm.action = "/acar/off_lease/off_lease_imgDelete.jsp";
	fm.target = "i_no";
	fm.imgnum.value = imgnum;
	fm.submit();
}
function imgBig(){
	var imgName = document.form1.carImg.value;
	window.open("/acar/off_lease/off_lease_imgBig.jsp?car_mng_id=<%=car_mng_id%>&imgName="+imgName,"imgBig", "left=200, top=100, width=620, height=420, resizable=no, scorllbars=no");
}
-->
</script>
</head>
<body>
<form name="form1" action="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="imgnum" value="">
<input type="hidden" name="apprsl_dt_s" value="">
<input type="hidden" name="gubun" value="">
  <table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr> 
      <td align='left' colspan="2"> <<�⺻����>> </td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding='0' >
          <tr> 
            <td class='title' width='120'>��������</td>
            <td class='title' width="130">������ȣ</td>
            <td class='title' width="150">���ʵ����</td>
            <td class='title' width="150">�����</td>
            <td class='title' width="250">�����ȣ</td>
          </tr>
          <tr> 
            <td align="center" width="120"><%=detail.getCar_l_cd()%></td>
            <td align="center" width="130"><%=detail.getCar_no()%></td>
            <td align="center" width="150"><%=AddUtil.ChangeDate2(detail.getInit_reg_dt())%></td>
            <td align="center" width="150"><%=AddUtil.ChangeDate2(detail.getDlv_dt())%></td>
            <td align="center" width="250"><%=detail.getCar_num()%></td>
          </tr>
          <tr> 
            <td class='title' width="120">�뵵</td>
            <td class='title' width="130">����</td>
            <td class='title' width="150">��ⷮ</td>
            <td class='title' width="150">����</td>
            <td class='title' width="250">����</td>
          </tr>
          <tr> 
            <td align="center" width="120"> 
              <%if(detail.getCar_use().equals("1")){%>
              ������ 
              <%}else{%>
              �ڰ��� 
              <%}%>
            </td>
            <td align="center" width="130"><%=c_db.getNameByIdCode("0039", "", detail.getFuel_kd())%></td>
            <td align="center" width="150"><%=detail.getDpm()%> cc</td>
            <td align="center" width="150"><%=detail.getCar_y_form()%></td>
            <td align="center" width="250"><%=detail.getCar_form()%> </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align='left' colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td align='left' colspan="2"> <<��������>> </td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding='0' width="800" >
          <tr> 
            <td rowspan="6"  width="130" align="center"> <img src="<%if(!imgfile[0].equals("")){%>	
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile1()%>.gif
						<%}else if(!detail.getImgfile2().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile2()%>.gif
						<%}else if(!detail.getImgfile3().equals("")){%>
					        https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile3()%>.gif
						<%}else if(!detail.getImgfile4().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile4()%>.gif
						<%}else if(!detail.getImgfile5().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile5()%>.gif
						<%}else{}%>" 
						name="carImg" 
						value = "<%if(!imgfile[0].equals("")){%>	
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile1()%>.gif
						<%}else if(!detail.getImgfile2().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile2()%>.gif
						<%}else if(!detail.getImgfile3().equals("")){%>
					        https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile3()%>.gif
						<%}else if(!detail.getImgfile4().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile4()%>.gif
						<%}else if(!detail.getImgfile5().equals("")){%>
							https://fms3.amazoncar.co.kr/images/carImg/<%=detail.getImgfile5()%>.gif
						<%}else{}%>" 
						border="0" width="120" height="120" onclick="javascript:imgBig()"></td>
            <td rowspan="2"  class='title' width="50">����</td>
            <td class='title' rowspan="2" width="120">��Ī</td>
            <td class="title" colspan="3">�Һ��ڰ�</td>
            <td class="title" colspan="3">���԰�</td>
          </tr>
          <tr> 
            <td  class='title' width="80">���ް�</td>
            <td  class='title' width="80">�ΰ���</td>
            <td  class='title' width="90">�հ�</td>
            <td  class='title' width="80">���ް�</td>
            <td  class='title' width="80">�ΰ���</td>
            <td  class='title' width="90">�հ�</td>
          </tr>
          <tr> 
            <td width="50" align="center" >����</td>
            <td align="center" width="120" ><span title='<%=detail.getCar_nm()%>'><%=AddUtil.subData(detail.getCar_nm(),8)%></span></td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_cs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_cv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getCar_cv_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_fs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_fv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getCar_fv_amt())%>&nbsp;</td>
          </tr>
          <tr> 
            <td width="50" align="center" >�ɼ�</td>
            <td align="center" width="120" ><span title='<%=detail.getOpt()%>'><%=AddUtil.subData(detail.getOpt(),8)%></span></td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getOpt_cs_amt())%>&nbsp;</td>
            <td align="right" width="80"><%=AddUtil.parseDecimal(detail.getOpt_cv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getOpt_cs_amt()+detail.getOpt_cv_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getOpt_fs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getOpt_fv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getOpt_fs_amt()+detail.getOpt_fv_amt())%>&nbsp;</td>
          </tr>
          <tr> 
            <td width="50" align="center" >����</td>
            <td align="center" width="120" ><span title='<%=detail.getColo()%>'><%=AddUtil.subData(detail.getColo(),8)%></span></td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getClr_cs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getClr_cv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getClr_cs_amt()+detail.getClr_cv_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getClr_fs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getClr_fv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getClr_fs_amt()+detail.getClr_fv_amt())%>&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="2" align="center">����DC</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getDc_cs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getDc_cv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getDc_cs_amt()+detail.getDc_cv_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getDc_fs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getDc_fv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getDc_fs_amt()+detail.getDc_fv_amt())%>&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> 
              <%
			int j=1;
			for(int i=0; i<imgfile.length; i++){
				if(!imgfile[i].equals("")){%>
              <a href="#" onClick="show(<%=i%>)">
              <%if(j==1){%>
              ���� 
              <%}else if(j==2){%>
              �ǳ� 
              <%}else if(j==3){%>
              �� 
              <%}else if(j==4){%>
              ���� 
              <%}else if(j==5){%>
              �� 
              <%}%>
              </a> 
              <%}
				j++;
			}
			for(int i=0; i<imgfile.length; i++){
				if(!imgfile[i].equals("")){%>
              <script language="javascript">
						imgnum = <%=i%>;
						//alert(imgnum);
					</script> 
              <%break;
				}
			}
			if(imgfile[0].equals("") && imgfile[1].equals("") && imgfile[2].equals("") && imgfile[3].equals("") && imgfile[4].equals("")){%>
              �̹������� 
              <%}%>
            </td>
            <td colspan="2" align="center">Ź�۷�</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getSd_cs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getSd_cv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getSd_cs_amt()+detail.getSd_cv_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getSd_fs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getSd_fv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><%=AddUtil.parseDecimal(detail.getSd_fs_amt()+detail.getSd_fv_amt())%>&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> 
              <%if(auth_rw.equals("4")||auth_rw.equals("6")){
				if(imgfile[0].equals("") && imgfile[1].equals("") && imgfile[2].equals("") && imgfile[3].equals("") && imgfile[4].equals("")){%>
              <a href='javascript:imgAppend();' onMouseOver="window.status=''; return true"> 
              <img src="/images/add.gif" width="50" height="18" align="absmiddle" border="0" alt="�߰�"></a> 
              <%}else{%>
              <a href='javascript:imgAppend();' onMouseOver="window.status=''; return true"> 
              <img src="/images/add.gif" width="50" height="18" align="absmiddle" border="0" alt="�߰�"></a> 
              &nbsp;&nbsp;<a href='javascript:imgDelete();' onMouseOver="window.status=''; return true"> 
              <img src="/images/del.gif" width="50" height="18" align="absmiddle" border="0" alt="����"></a> 
              <%}
			 }%>
            </td>
            <td colspan="2" align="center">�� ��</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getOpt_cs_amt()+detail.getClr_cs_amt()+detail.getSd_cs_amt()+detail.getDc_cs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_cv_amt()+detail.getOpt_cv_amt()+detail.getClr_cv_amt()+detail.getSd_cv_amt()+detail.getDc_cv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><b><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getOpt_cs_amt()+detail.getClr_cs_amt()+detail.getSd_cs_amt()+detail.getDc_cs_amt()+detail.getCar_cv_amt()+detail.getOpt_cv_amt()+detail.getClr_cv_amt()+detail.getSd_cv_amt()+detail.getDc_cv_amt())%></b>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getOpt_fs_amt()+detail.getClr_fs_amt()+detail.getSd_fs_amt()+detail.getDc_fs_amt())%>&nbsp;</td>
            <td align="right" width="80" ><%=AddUtil.parseDecimal(detail.getCar_fv_amt()+detail.getOpt_fv_amt()+detail.getClr_fv_amt()+detail.getSd_fv_amt()+detail.getDc_fv_amt())%>&nbsp;</td>
            <td align="right" width="90" ><b><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getOpt_fs_amt()+detail.getClr_fs_amt()+detail.getSd_fs_amt()+detail.getDc_fs_amt()+detail.getCar_fv_amt()+detail.getOpt_fv_amt()+detail.getClr_fv_amt()+detail.getSd_fv_amt()+detail.getDc_fv_amt())%></b>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align='left' colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td align='left' colspan="2"> <<��Ÿ����>></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' width='120'> �Һα�����</td>
            <td align='center' width="180"> 
              <%if(detail.getBank_nm().equals("")){%>
              - 
              <%}else{%>
              <%=detail.getBank_nm()%> 
              <%}%>
            </td>
            <td class='title' width='100'> ����ݾ�</td>
            <td align='center' width='150'><%=AddUtil.parseDecimal(detail.getLend_prn())%>&nbsp;��</td>
            <td class='title' width='100'>��ȯ�����ܾ�</td>
            <td align='center' width='150'><%=AddUtil.parseDecimal(detail.getLend_rem())%>&nbsp;��</td>
          </tr>
          <tr> 
            <td class='title' width='120'> �����</td>
            <td align='center' width="180"><%= detail.getIns_com_nm() %></td>
            <td class='title' width='100'> ������ȿ�Ⱓ</td>
            <td align='center' width='150'><%= AddUtil.ChangeDate2(detail.getIns_exp_dt()) %></td>
            <td class='title' >��ȯ������</td>
            <td align="center" width='150'><%=AddUtil.ChangeDate2(detail.getAlt_end_dt())%></td>
          </tr>
          <tr> 
            <td class='title' width="120">����˻���ȿ�Ⱓ</td>
            <td align='center' width="180"><%=AddUtil.ChangeDate2(detail.getMaint_st_dt())%> 
              ~ <%=AddUtil.ChangeDate2(detail.getMaint_end_dt())%></td>
            <td class='title' width="100"> ��������Ÿ�</td>
            <td align="center" width='150'><%=AddUtil.parseDecimal(detail.getToday_dist())%> 
              km</td>
            <td class="title" width="100" align="center">�������Ÿ�</td>
            <td align="center" ><%=AddUtil.parseDecimal(detail.getAverage_dist())%> 
              km</td>
          </tr>
          <tr> 
            <td class='title' width="120">������ȿ�Ⱓ</td>
            <td align='center' width="180"><%=AddUtil.ChangeDate2(detail.getTest_st_dt())%> 
              ~ <%=AddUtil.ChangeDate2(detail.getTest_end_dt())%></td>
            <td class='title' width="100">��������</td>
            <td align="center" width='150'> 
              <%if(detail.getCar_cha_yn().equals("1")){%>
              &nbsp;���� 
              <%}else{%>
              &nbsp;���� 
              <%}%>
            </td>
            <td class="title" width="100" align="center">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align='left' colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td align='left'><<��ǰ��>></td>
      <td align="right"> 
        <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
        <%if(apprsl_car_mng_id.equals("")){%>
        <a href='javascript:apprslUpd("i");' onMouseOver="window.status=''; return true"> 
        <img src="/images/reg.gif" width="50" height="18" align="absmiddle" border="0" alt="���"></a> 
        <%}else{%>
        <a href='javascript:apprslUpd("u");' onMouseOver="window.status=''; return true"> 
        <img src="/images/update.gif" width="50" height="18" align="absmiddle" border="0" alt="����"></a> 
        <%}%>
        <%}%>
      </td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" >
          <tr> 
            <td class='title' width='120'> ��ü��</td>
            <td width='180'>&nbsp; 
              <select name='apprsl_lev'>
                <option value='0'>����</option>
                <option value='1' <%if(detail.getLev().equals("1")){%>selected<%}%>>��</option>
                <option value='2' <%if(detail.getLev().equals("2")){%>selected<%}%>>��</option>
                <option value='3' <%if(detail.getLev().equals("3")){%>selected<%}%>>��</option>
              </select>
            </td>
            <td class='title' width='100'>������</td>
            <td align="center" width='150' > 
              <input  class="text" type="text" name="apprsl_dt" size="20" value="<%=AddUtil.ChangeDate2(detail.getApprsl_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
            </td>
            <td class='title' width='100'>&nbsp;</td>
            <td width='150'>&nbsp; </td>
          </tr>
          <tr> 
            <td class='title' width="120">�򰡿���</td>
            <td colspan="5">&nbsp; 
              <textarea  class="textarea" name="apprsl_reason" cols="70" rows="2"><%=detail.getReason()%></textarea>
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">��������</td>
            <td colspan="5">&nbsp; 
              <input  class="text" type="text" name="apprsl_car_st" size="70" value="<%=detail.getCar_st()%>">
            </td>
          </tr>
          <tr> 
            <td class='title' width="120">�������</td>
            <td width="180"> &nbsp; 
              <%if(detail.getAccident_yn().equals("1")){%>
              &nbsp;���� 
              <%}else{%>
              &nbsp;���� 
              <%}%>
            </td>
            <td width="100" class='title'>�����</td>
            <td width="150">&nbsp; 
              <select name="damdang_id">
                <option value='' <%if(detail.getDamdang_id().equals("")){%>selected<%}%>>����</option>
                <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	
%>
                <option value='<%=user.get("USER_ID")%>' <%if(detail.getDamdang_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%
						}
					}		%>
              </select>
            </td>
            <td width="100" class='title'>����������</td>
            <td width="150">&nbsp; 
              <%if(login.getAcarName(detail.getModify_id()).equals("error")){%>
              &nbsp; 
              <%}else{%>
              <%=login.getAcarName(detail.getModify_id())%> 
              <%}%>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
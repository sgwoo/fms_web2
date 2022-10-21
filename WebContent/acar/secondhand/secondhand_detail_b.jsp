<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_yb.*"%>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	Offls_ybBean detail = olyD.getYb_detail_20090907(car_mng_id);
	
	String imgfile[] = new String[5];
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                		
	String content_code = "";
	String content_seq  = "";
	
	Vector attach_vt = new Vector();
	int attach_vt_size = 0;
	
		
	for(int i=0;i<5;i++){
                	               			
		content_code = "APPRSL";
		content_seq  = car_mng_id+""+String.valueOf(i+1);

		attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
		attach_vt_size = attach_vt.size();	

		if(attach_vt_size > 0){
			for (int j = 0 ; j < attach_vt_size ; j++){
 				Hashtable ht = (Hashtable)attach_vt.elementAt(j);	
 				imgfile[i] = "https://fms3.amazoncar.co.kr"+String.valueOf(ht.get("SAVE_FOLDER"))+""+String.valueOf(ht.get("SAVE_FILE"));
 			}
 		}else{
 			imgfile[i] = "";
 		}
 	}


	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//��������
	Hashtable sh_ht = shDb.getShBase(car_mng_id);	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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

carImage[0].src = "<%=imgfile[0]%>";
carImage[1].src = "<%=imgfile[1]%>";
carImage[2].src = "<%=imgfile[2]%>";
carImage[3].src = "<%=imgfile[3]%>";
carImage[4].src = "<%=imgfile[4]%>";

function show(n){
	document.images["carImg"].src = carImage[n].src;
	document.form1.carImg.value = carImage[n].src;
	imgnum = n;
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
		//������������� ȣ��		
		window.open("/acar/res_search/car_img_add_all.jsp?c_id=<%=car_mng_id%>&car_no=<%=detail.getCar_no()%>", "imgAppend", "left=300, top=200, width=820, height=600, resizable=no, scorllbars=no");
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
	//����ũ�Ժ���	
	window.open("/acar/secondhand_hp/bigimg.jsp?c_id=<%=car_mng_id%>","imgBig", "left=200, top=100, width=800, height=600, resizable=yes, scorllbars=no");
}
//-->
</script>
</head>
<body>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="imgnum" value="">
<input type="hidden" name="gubun" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td align='left' colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�⺻����</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class='title' width=16%>��������</td>
                    <td class='title' width=21%>������ȣ</td>
                    <td class='title' width=21%>���ʵ����</td>
                    <td class='title' width=21%>�����</td>
                    <td class='title' width=21%>�����ȣ</td>
                </tr>
                <tr> 
                    <td align="center"><%=detail.getCar_l_cd()%></td>
                    <td align="center"><%=detail.getCar_no()%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(detail.getInit_reg_dt())%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(detail.getDlv_dt())%></td>
                    <td align="center"><%=detail.getCar_num()%></td>
                </tr>
                <tr> 
                    <td class='title'>�뵵</td>
                    <td class='title'>����</td>
                    <td class='title'>��ⷮ</td>
                    <td class='title'>�𵨿���</td>
                    <td class='title'>����</td>
                </tr>
                <tr> 
                    <td align="center"> <%if(detail.getCar_use().equals("1")){%>
                      ��Ʈ����� 
                      <%}else{%>
                      ��������� 
                      <%}%> </td>
                    <td align="center"><%=c_db.getNameByIdCode("0039", "", detail.getFuel_kd())%></td>
                    <td align="center"><%=detail.getDpm()%> cc</td>
                    <td align="center"><%=detail.getCar_y_form()%></td>
                    <td align="center"><%=detail.getCar_form()%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align='left' colspan="2">&nbsp;</td>
    </tr>
    <tr> 
        <td align='left' colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td rowspan="6"  width=16% align="center"> <img src="<%if(!imgfile[0].equals("")){%>	
							<%=imgfile[0]%>
						<%}else if(!detail.getImgfile2().equals("")){%>
							<%=imgfile[1]%>
						<%}else if(!detail.getImgfile3().equals("")){%>
					                <%=imgfile[2]%>
						<%}else if(!detail.getImgfile4().equals("")){%>
							<%=imgfile[3]%>
						<%}else if(!detail.getImgfile5().equals("")){%>
							<%=imgfile[4]%>
						<%}else{%>
							https://fms3.amazoncar.co.kr/images/no_photo.gif
						<%}%>" 
						name="carImg" 
						value = "<%if(!imgfile[0].equals("")){%>	
							<%=imgfile[0]%>
						<%}else if(!detail.getImgfile2().equals("")){%>
							<%=imgfile[1]%>
						<%}else if(!detail.getImgfile3().equals("")){%>
					                <%=imgfile[2]%>
						<%}else if(!detail.getImgfile4().equals("")){%>
							<%=imgfile[3]%>
						<%}else if(!detail.getImgfile5().equals("")){%>
							<%=imgfile[4]%>
						<%}else{%>
							https://fms3.amazoncar.co.kr/images/no_photo.gif
						<%}%>" 
						border="0" width="150" height="120" onclick="javascript:imgBig()"
						alt="ū�̹����� ���Ƿ��� Ŭ��!"></td>
                    <td rowspan="2"  class='title' width=7%>����</td>
                    <td class='title' rowspan="2" width=14%>��Ī</td>
                    <td class="title" colspan="3">�Һ��ڰ�</td>
                    <td class="title" colspan="3">���԰�</td>
                </tr>
                <tr> 
                    <td  class='title' width=10%>���ް�</td>
                    <td  class='title' width=11%>�ΰ���</td>
                    <td  class='title' width=11%>�հ�</td>
                    <td  class='title' width=10%>���ް�</td>
                    <td  class='title' width=10%>�ΰ���</td>
                    <td  class='title' width=11%>�հ�</td>
                </tr>
                <tr> 
                    <td align="center" >����</td>
                    <td align="center"><span title='<%=detail.getCar_jnm()+" "+detail.getCar_nm()%>'><%=AddUtil.subData(detail.getCar_jnm()+" "+detail.getCar_nm(),8)%></span></td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getCar_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getCar_fv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >�ɼ�</td>
                    <td align="center"><span title='<%=detail.getOpt()%>'><%=AddUtil.subData(detail.getOpt(),8)%></span></td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_cs_amt()+detail.getOpt_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_fs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_fv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_fs_amt()+detail.getOpt_fv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >����</td>
                    <td align="center"><span title='<%=detail.getColo()%>'><%=AddUtil.subData(detail.getColo(),8)%></span></td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_cs_amt()+detail.getClr_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_fs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_fv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_fs_amt()+detail.getClr_fv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <td colspan="2" class=title align="center">����DC</td>
                    <td align="right">0
                        <%//=AddUtil.parseDecimal(detail.getDc_cs_amt())%>
                      &nbsp;</td>
                    <td align="right">0
                        <%//=AddUtil.parseDecimal(detail.getDc_cv_amt())%>
                      &nbsp;</td>
                    <td align="right">0
                        <%//=AddUtil.parseDecimal(detail.getDc_cs_amt()+detail.getDc_cv_amt())%>
                      &nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getDc_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getDc_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getDc_cs_amt()+detail.getDc_cv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" rowspan='2'><%
        			int j=1;
        			for(int i=0; i<imgfile.length; i++){
        				if(!imgfile[i].equals("")){%> 
							<a href="#" onClick="show(<%=i%>)">
							<%if(j==1){%><img src=../images/center/button_front_s.gif align=absmiddle border=0>
        					<%}else if(j==2){%><img src=../images/center/button_in.gif align=absmiddle border=0>
        					<%}else if(j==3){%><img src=../images/center/button_back.gif align=absmiddle border=0>
        					<%}else if(j==4){%><img src=../images/center/button_back_s.gif align=absmiddle border=0>
        					<%}else if(j==5){%><img src=../images/center/button_front.gif align=absmiddle border=0>
        					<%}%>
							</a>
        				<%}
        				j++;
        			}
        			for(int i=0; i<imgfile.length; i++){
        				if(!imgfile[i].equals("")){%> <script language="javascript">
        						imgnum = <%=i%>;
        						//alert(imgnum);
        					</script> <%break;
        				}
        			}
        			if(imgfile[0].equals("") && imgfile[1].equals("") && imgfile[2].equals("") && imgfile[3].equals("") && imgfile[4].equals("")){%>
                      <a href='javascript:imgAppend();'><img src=../images/center/button_in_plus.gif align=absmiddle border=0></a>
                      <%}%> </td>
                    <td colspan="2" align="center" class=title>Ź�۷�</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_cs_amt()+detail.getSd_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_fs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_fv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_fs_amt()+detail.getSd_fv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <!--
					<td align="center"> <%if(auth_rw.equals("4")||auth_rw.equals("6")){
        				if(imgfile[0].equals("") && imgfile[1].equals("") && imgfile[2].equals("") && imgfile[3].equals("") && imgfile[4].equals("")){%> <a href='javascript:imgAppend();' onMouseOver="window.status=''; return true"> 
                      <img src=../images/center/button_in_plus.gif align=absmiddle border=0></a> </a> 
                      <%}else{%> <a href='javascript:imgAppend();'> 
                      <img src=../images/center/button_in_plus.gif align=absmiddle border=0></a> 
                      &nbsp;&nbsp;<a href='javascript:imgDelete();'> 
                      <img src=../images/center/button_in_delete.gif align=absmiddle border=0></a> 
                      <%}
        			 }%> </td>
					--> 
                    <td colspan="2" align="center" class=title>�� ��</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getOpt_cs_amt()+detail.getClr_cs_amt()+detail.getSd_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cv_amt()+detail.getOpt_cv_amt()+detail.getClr_cv_amt()+detail.getSd_cv_amt())%>&nbsp;</td>
                    <td align="right"><b><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getOpt_cs_amt()+detail.getClr_cs_amt()+detail.getSd_cs_amt()+detail.getCar_cv_amt()+detail.getOpt_cv_amt()+detail.getClr_cv_amt()+detail.getSd_cv_amt())%></b>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getOpt_fs_amt()+detail.getClr_fs_amt()+detail.getSd_fs_amt()-detail.getDc_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fv_amt()+detail.getOpt_fv_amt()+detail.getClr_fv_amt()+detail.getSd_fv_amt()-detail.getDc_cv_amt())%>&nbsp;</td>
                    <td align="right"><b><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getOpt_fs_amt()+detail.getClr_fs_amt()+detail.getSd_fs_amt()-detail.getDc_cs_amt()+detail.getCar_fv_amt()+detail.getOpt_fv_amt()+detail.getClr_fv_amt()+detail.getSd_fv_amt()-detail.getDc_cv_amt())%></b>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align='left' colspan="2">&nbsp;</td>
    </tr>
    <tr> 
        <td align='left' colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��Ÿ����</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0"  width=100%>
                <tr> 
                    <td class='title' width=16%> �Һα�����</td>
                    <td align='center' width=21%> <%if(detail.getBank_nm().equals("")){%>
                      - 
                      <%}else{%> <%=detail.getBank_nm()%> <%}%> </td>
                    <td class='title'  width=14%> ����ݾ�</td>
                    <td align='center' width=18%><%=AddUtil.parseDecimal(detail.getLend_prn())%>&nbsp;��</td>
                    <td class='title' width=13%>��ȯ�����ܾ�</td>
                    <td align='center' width=18%><%=AddUtil.parseDecimal(detail.getLend_rem())%>&nbsp;��</td>
                </tr>
                <tr> 
                    <td class='title'> �����</td>
                    <td align='center'><%= detail.getIns_com_nm() %></td>
                    <td class='title'> ������ȿ�Ⱓ</td>
                    <td align='center'><%= AddUtil.ChangeDate2(detail.getIns_exp_dt()) %></td>
                    <td class='title'>��ȯ������</td>
                    <td align="center"><%=AddUtil.ChangeDate2(detail.getAlt_end_dt())%></td>
                </tr>
                <tr> 
                    <td class='title'>����˻���ȿ�Ⱓ</td>
                    <td align='center'><%=AddUtil.ChangeDate2(detail.getMaint_st_dt())%> ~ <%=AddUtil.ChangeDate2(detail.getMaint_end_dt())%></td>
                    <td class='title'> ��������Ÿ�</td>
                    <td align="center"><%=AddUtil.parseDecimal(detail.getToday_dist())%> km</td>
                    <td class="title" align="center">�������Ÿ�</td>
                    <td align="center" ><%=AddUtil.parseDecimal(detail.getAverage_dist())%> km</td>
                </tr>
                <tr> 
                    <td class='title'>������ȿ�Ⱓ</td>
                    <td align='center'><%=AddUtil.ChangeDate2(detail.getTest_st_dt())%> ~ <%=AddUtil.ChangeDate2(detail.getTest_end_dt())%></td>
					<td class="title" align="center">���ɸ�����</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sh_ht.get("CAR_END_DT")))%></td>
                    <td class='title'>��������</td>
                    <td align="center"> <%if(detail.getCar_cha_yn().equals("1")){%> &nbsp;���� 
                      <%}else{%> &nbsp;���� 
                      <%}%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align='left' colspan="2">&nbsp;</td>
    </tr>
    <tr> 
        <td align='left' colspan="2">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǰ��</span></td>
                    <td align="right">&nbsp;</td>
                </tr>
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
                <tr> 
                    <td class=line colspan="2"> 
                        <table border="0" cellspacing="1" cellpadding="0"  width=100%>
                            <tr> 
                                <td class='title' width=16%> ��ü��</td>
                                <td width=22%>
                                <%if(detail.getLev().equals("1")){%>
                                �� 
                                <%}else if(detail.getLev().equals("2")){%>
                                �� 
                                <%}else if(detail.getLev().equals("3")){%>
                                �� 
                                <% } %>
                                </td>
                                <td class='title' width='14%'>������</td>
                                <td align="center" width='18%'><%=AddUtil.ChangeDate2(detail.getApprsl_dt())%></td>
                                <td class='title' width='13%'>&nbsp;</td>
                                <td width='17%'>&nbsp; </td>
                            </tr>
                            <tr> 
                                <td class='title'>�򰡿���</td>
                                <td colspan="5"><%=detail.getReason()%></td>
                            </tr>
                            <tr> 
                                <td class='title'>��������</td>
                                <td colspan="5"><%=detail.getCar_st()%></td>
                            </tr>
                            <tr> 
                                <td class='title'>�������</td>
                                <td> 
                                <%if(detail.getAccident_yn().equals("1")){%>
                                ���� 
                                <%}else{%>
                                ���� 
                                <%}%>
                                </td>
                                <td class='title'>�����</td>
                                <td >
                                <%if(login.getAcarName(detail.getDamdang_id()).equals("error")){%>
                                &nbsp; 
                                <%}else{%>
                                <%=login.getAcarName(detail.getDamdang_id())%> 
                                <%}%>
                                </td>
                                <td class='title'>����������</td>
                                <td>&nbsp; 
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
                <tr>
                    <td></td>
                </tR>
                
                <tr> 
                    <td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ݳ��� ����������</span></td>
                    <td align="right">&nbsp; </td>
                </tr>
                <tr>
                    <td class=line2 colspan=2></td>
                </tR>
                <tr> 
                    <td colspan="2" align='left' class="line">
                        <table border="0" cellspacing="1" cellpadding="0"  width=100%>
                            <tr> 
                                <td class='title' width=16%> ������</td>
                                <td width=84% colspan="5"> 
                                <%if(detail.getDriver().equals("1")){%>
                                �ӿ� 
                                <%}else if(detail.getDriver().equals("2")){%>
                                ���� 
                                <%}%>
                                </td>
                            </tr>
                        </table>
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
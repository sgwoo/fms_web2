<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "java.util.*, acar.util.*, acar.offls_cmplt.*"%>
<%@ page import="org.json.simple.JSONObject, org.json.simple.JSONArray" %>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");

	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String dt		= request.getParameter("dt")		==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")	==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")	==null?"":request.getParameter("ref_dt2");
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	
	Vector jarr = olcD.getSuiStatLst(dt, ref_dt1, ref_dt2, gubun1, gubun2, gubun3, s_kd, t_wd);
	int jarr_size = jarr.size();
	
	String jobjString = "";
	int k =  0;
	
	if(jarr_size >= 0 ) {
		
		jobjString = "data={ rows:[ ";

		for(int i = 0 ; i < jarr_size ; i++) {
			
			Hashtable ht = (Hashtable)jarr.elementAt(i);
			
			if(i != 0 ){
				jobjString += ",";
			}	
			
			k =  i+1;
	 	 	jobjString +=  " { id:" + k + ",";
	 	 	jobjString +=  "data:[\""  +  k + "\",";//���� 0
	 	 	
	 	 	jobjString +=  "\""+ht.get("CAR_NO") + "\",";//������ȣ 1
	 	 	jobjString +=  "\""+ht.get("JG_CODE") + "\",";//�����ڵ� 2
			jobjString +=  "\""+String.valueOf(ht.get("CAR_NAME")) + "\",";//���� 3
			jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT"))) + "\",";//���ʵ���� 4	 	 	
	 	 	jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_DT"))) + "\",";//�Ű����� 5
	 	 	jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_MON"))) + "\",";//�Ű��� 6
	 	 	jobjString +=  "\""+String.valueOf(ht.get("CAR_AMT1")) + "\",";//�����Һ��ڰ� 7
	 	 	jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("CAR_MON")),2) + "\",";//���� 8	
	 	 	
	 	 	//20210915 �߰�
	 	 	jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("M_VAR")),2) + "\",";//�����ܰ������� 9
	 	 	jobjString +=  "\""+String.valueOf(ht.get("N_VAR")) + "\",";//�����ܰ����� 10
	 	 	
	 	 	//�ܰ�����
	 	 	jobjString +=  "\""+String.valueOf(ht.get("TOT_PNL_AMT")) + "\",";//�ܰ��Ѽ��� 11
	 	 	jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("TOT_PNL_PER")),2) + "\",";//�����Һ��ڰ��ݴ�� 12
	 	 	jobjString +=  "\""+String.valueOf(ht.get("T_PNL_AMT")) + "\",";//�ܰ������հ� 13
	 	 	
	 	 	if(AddUtil.parseInt(String.valueOf(ht.get("J_OVER_AMT"))) < 0 ){
	 	 		jobjString +=  "\""+"0" + "\",";//�ʰ�����뿩���հ� 14
	 	 		jobjString +=  "\""+(AddUtil.parseInt(String.valueOf(ht.get("J_OVER_AMT")))*-1) + "\",";//ȯ�޴뿩���հ� 15
	 	 	}else{
	 	 		jobjString +=  "\""+String.valueOf(ht.get("J_OVER_AMT")) + "\",";//�ʰ�����뿩���հ� 14
	 	 		jobjString +=  "\""+"0" + "\",";//ȯ�޴뿩���հ� 15
	 	 	}
	 	 	
	 		//jobjString +=  "\""+String.valueOf(ht.get("BC_B_D")) + "\",";//�縮���ʱ⿵���������ݿ��� 13
	 	 	//jobjString +=  "\""+String.valueOf(ht.get("J_SERV_AMT")) + "\",";//�縮���Ǽ����� 14
	 	 	
	 		jobjString +=  "\""+String.valueOf(ht.get("COMM_AMT")) + "\",";//�Ű��������հ�(����/��ǰ/����ǰ������/�߰�������/Ź�۷�) 15
	 		//���� �߰���������
	 		jobjString +=  "\""+String.valueOf(ht.get("AMT5")) + "\",";//�߰��������� �߰� 16
	 		//��Ÿ �뿩�Ⱓ
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("CONT_MON1")),2) + "\",";//����� �ܰ����� �񱳽� ������ �뿩�Ⱓ(����) 17
	 		
	 		//20210915 �߰�
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("L_VAR")),2) + "\",";//�����ԱⰣ�ܰ�����ȿ�� 18
	 		
	 		//20211021 �߰�
	 		jobjString +=  "\""+String.valueOf(ht.get("L_VAR_AMT")) + "\",";//�����ԱⰣ�ܰ�����ȿ�� �ݾ�(�����Һ��ڰ��ݴ��) 19
	 		
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("CONT_MON2")),2) + "\",";//�����ܰ� ������� �߰��̿�Ⱓ 20
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("CONT_MON3")),2) + "\",";//����Ʈ �뿩�Ⱓ 21	 		
	 		//���� (���Կɼ� �ִ� ���� ����� ����)
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT1"))) + "\",";//�뿩������ 22
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT1"))) + "\",";//�뿩������ 23
	 		jobjString +=  "\""+String.valueOf(ht.get("CON_MON1")) + "\",";//���� �뿩�Ⱓ 24
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("R_CON_MON1")),2) + "\",";//���� �뿩�Ⱓ 25
	 		jobjString +=  "\""+ht.get("JAN_ST1") + "\",";//�����ܰ� ���� DATA 26
	 		jobjString +=  "\""+String.valueOf(ht.get("JAN_AMT1")) + "\",";//�����ܰ� 27
	 		//���Կɼ� ���� ���� ����
	 		jobjString +=  "\""+String.valueOf(ht.get("CAR_AMT2")) + "\",";//��������� �߰�����(����������Ǹ�ǥ��) 28
	 		jobjString +=  "\""+String.valueOf(ht.get("PNL_AMT2")) + "\",";//����������� 29
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT2"))) + "\",";//�뿩������ 30
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT2"))) + "\",";//�뿩������ 31
	 		jobjString +=  "\""+String.valueOf(ht.get("CON_MON2")) + "\",";//���� �뿩�Ⱓ 32
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("R_CON_MON2")),2) + "\",";//���� �뿩�Ⱓ 33
	 		jobjString +=  "\""+ht.get("JAN_ST2") + "\",";//�����ܰ� ���� DATA 34
	 		jobjString +=  "\""+String.valueOf(ht.get("JAN_AMT2")) + "\",";//�����ܰ� 35
	 		//�縮��1 (���Կɼ� �ִ� �縮�� ���� �� ����, �縮�����ʰ��)
	 		jobjString +=  "\""+String.valueOf(ht.get("CAR_AMT3")) + "\",";//�縮�� ������ �߰�����(���ʰ��) 36
	 		jobjString +=  "\""+String.valueOf(ht.get("PNL_AMT3")) + "\",";//�緯��1 ����(���ʰ��) 37
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT3"))) + "\",";//�뿩������ 38
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT3"))) + "\",";//�뿩������ 39
	 		jobjString +=  "\""+String.valueOf(ht.get("CON_MON3")) + "\",";//���� �뿩�Ⱓ 40
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("R_CON_MON3")),2) + "\",";//���� �뿩�Ⱓ 41
	 		jobjString +=  "\""+ht.get("JAN_ST3") + "\",";//�����ܰ� ���� DATA 42
	 		jobjString +=  "\""+String.valueOf(ht.get("JAN_AMT3")) + "\",";//�����ܰ� 43
	 		//�縮��1 (���Կɼ� ���� �縮�� ����, �縮�����ʰ���� ����)
	 		jobjString +=  "\""+String.valueOf(ht.get("CAR_AMT4")) + "\",";//�縮��1 ���� ������ �߰�����(���ʰ��) 44
	 		jobjString +=  "\""+String.valueOf(ht.get("PNL_AMT4")) + "\",";//�緯��1 ���� ����(���ʰ��) 45
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT4"))) + "\",";//�뿩������ 46
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT4"))) + "\",";//�뿩������ 47
	 		jobjString +=  "\""+String.valueOf(ht.get("CON_MON4")) + "\",";//���� �뿩�Ⱓ 48
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("R_CON_MON4")),2) + "\",";//���� �뿩�Ⱓ 49
	 		jobjString +=  "\""+ht.get("JAN_ST4") + "\",";//�����ܰ� ���� DATA 50
	 		jobjString +=  "\""+String.valueOf(ht.get("JAN_AMT4")) + "\",";//�����ܰ� 51
	 		//�縮��2~5 (���Կɼ� �ִ� �縮�� ���� �� ����)
	 		jobjString +=  "\""+String.valueOf(ht.get("CAR_AMT5")) + "\",";//�縮��2~5 ������ �߰����� 52
	 		jobjString +=  "\""+String.valueOf(ht.get("PNL_AMT5")) + "\",";//�緯��2~5 ���� 53
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT5"))) + "\",";//�뿩������ 54
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT5"))) + "\",";//�뿩������ 55
	 		jobjString +=  "\""+String.valueOf(ht.get("CON_MON5")) + "\",";//���� �뿩�Ⱓ 56
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("R_CON_MON5")),2) + "\",";//���� �뿩�Ⱓ 57
	 		jobjString +=  "\""+ht.get("JAN_ST5") + "\",";//�����ܰ� ���� DATA 58
	 		jobjString +=  "\""+String.valueOf(ht.get("JAN_AMT5")) + "\",";//�����ܰ� 59
	 		//�縮��2~5 (���Կɼ� ���� �縮�� ����)
	 		jobjString +=  "\""+String.valueOf(ht.get("CAR_AMT6")) + "\",";//�縮��2~5 ���� ������ �߰�����(���ʰ��) 60
	 		jobjString +=  "\""+String.valueOf(ht.get("PNL_AMT6")) + "\",";//�緯��2~5 ���� ����(���ʰ��) 61
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT6"))) + "\",";//�뿩������ 62
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT6"))) + "\",";//�뿩������ 63
	 		jobjString +=  "\""+String.valueOf(ht.get("CON_MON6")) + "\",";//���� �뿩�Ⱓ 64
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("R_CON_MON6")),2) + "\",";//���� �뿩�Ⱓ 65
	 		jobjString +=  "\""+ht.get("JAN_ST6") + "\",";//�����ܰ� ���� DATA 66
	 		jobjString +=  "\""+String.valueOf(ht.get("JAN_AMT6")) + "\",";//�����ܰ� 67
	 		//�Ű�
	 		jobjString +=  "\""+ht.get("END_ST") + "\",";//������� 68
	 		jobjString +=  "\""+ht.get("END_TYPE") + "\",";//�Ű����(���/���Կɼ�) 69
	 		jobjString +=  "\""+String.valueOf(ht.get("END_JAN_AMT")) + "\",";//���� ����� �����ܰ� 70
	 		jobjString +=  "\""+String.valueOf(ht.get("MM_PR")) + "\",";//�ŵ��� 71
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("MM_PER")),2) + "\",";//�����Һ��ڰ� ��� 72
	 		jobjString +=  "\""+String.valueOf(ht.get("MM_PNL_AMT")) + "\",";//�Ű�����(���� ��� �����ܰ� ����) 73
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("CAR_MON2")),2) + "\",";//���� 74
	 		jobjString +=  "\""+String.valueOf(ht.get("CAR_KM")) + "\",";//����Ÿ� 75
	 		jobjString +=  "\""+ht.get("ACTN_JUM") + "\",";//����� ���� 76
	 		jobjString +=  "\""+ht.get("MIGR_ST") + "\",";//������������ 77
	 		jobjString +=  "\""+String.valueOf(ht.get("A_SERV_AMT")) + "\",";//�������� 78
	 		jobjString +=  "\""+ht.get("CAR_NUM") + "\",";//�����ȣ 79
	 		jobjString +=  "\""+ht.get("JA_MON") + "\",";//�ڻ��������� 80
	 		jobjString +=  "\""+ht.get("CAR_CNG_YN") + "\",";//����������(�ش�1,���ش�0) 81
	 		jobjString +=  "\""+ht.get("JG_2") + "\"]";//�Ϲݽ¿�LPG����(�ش�1,���ش�0) 82
	 		
	 	 	jobjString += "}";
		}	
		jobjString += "]};";
	} 
	
%>

<!DOCTYPE html>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<style type="text/css">
	html, body {height: 93%;	}
	input.whitenum {text-align: right;  border-width: 0; }
	table.hdr td {	height: 30px !important;	}
</style>
<!--Grid-->
<script>
<%=jobjString%>
</script>
<script language="JavaScript">
<!--
	function sui_help_cont(){
		var SUBWIN= "view_stat_sui_help.jsp";
		window.open(SUBWIN, "View_Help", "left=50, top=50, width=1300, height=900, resizable=yes, scrollbars=yes");
	}
//-->
</script>
</head>
<body leftmargin="15">
<table border="0" cellspacing="0" cellpadding="0" width=100% height="35px">
	<tr>
		<td>
		   <a href="javascript:myGrid.toExcel('/grid-excel/generate');"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
		</td>        
    </tr>
</table>
<div id="gridbox" style="width:100%;height:100%; margin: 5px 0 5px 0;"></div>
<table border="0" cellspacing="0" cellpadding="0" width=100% height="25px">
    <tr> 
        <td width="*" align="left" style="font-size: 9pt;">
            * �� �Ǽ� : <span id="gridRowCount">0</span>��  &nbsp;&nbsp; <a href='javascript:sui_help_cont()' title='����'><img src=/acar/images/center/button_exp.gif border=0 align=absmiddle></a>
        </td>
        <td width="10%">
			<div id="a_1" style="color:red;">Loading</div>
        </td>
        <td width="70%" align="right" style="font-size: 9pt;">
        	<span>* ��������� 2009��1��1�Ϻ��� * ��������/���°�/�����ܰ�0/�����������/�����뿩 ���� ����</span>
        </td>
    </tr>    
</table>
</body>

<script>

var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("");//��0-79��(80��)
	
	//������̺�
	myGrid.setHeader    ("����,������ȣ,�����ڵ�,����,���������,�Ű�����,�Ű���,�����Һ��ڰ���,����,�ܰ�����,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,����,����� �ܰ����� ����� ������ �Ⱓ �� �ܰ� ����ȿ��,#cspan,#cspan,�����ܰ� ������� ���� �̿�Ⱓ,����Ʈ �뿩�Ⱓ,���� (���Կɼ� �ִ� ���� ���� �� ����),#cspan,#cspan,#cspan,#cspan,#cspan,���Կɼ� ���� ���� ����,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,�縮��1 (���Կɼ� �ִ� �縮�� ���� �� ����) (�縮�� ���ʰ��),#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,���Կɼ� ���� �縮��1 ���� (�縮�� ���ʰ���� ����),#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,�縮��2~5 (���Կɼ� �ִ� �縮�� ���� �� ����),#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,���Կɼ� ���� �縮��2~5 ����,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,�������,�Ű����,�Ű�,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,�����ȣ,�ڻ���������,�����������(�ش�1),�Ϲݽ¿�LPG����(�ش�1)");
	//�� �ʺ� �ȼ� ������ ����
	myGrid.setInitWidths("40,80,80,150,90,90,70,105,50,70,100,100,70,100,100,100,100,100,70,70,100,70,70,90,90,80,80,80,100,90,90,90,90,80,80,80,100,90,90,90,90,80,80,80,100,90,90,90,90,80,80,80,100,90,90,90,90,80,80,80,100,90,90,90,90,80,80,80,100,100,80,100,100,70,90,50,70,60,80,100,150,70,80,80");
	//��������(str,int,date,na) : ���� int,���� str
	myGrid.setColSorting("int,str,str,str,str,str,str,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,str,str,int,int,int,int,int,int,str,str,int,int,int,int,int,int,str,str,int,int,int,int,int,int,str,str,int,int,int,int,int,int,str,str,int,int,int,int,int,int,str,str,int,int,int,int,str,str,int,int,int,int,int,int,str,str,int,str,int,int,int");
	//�� ����(dyn,ed,txt,price,ch,coro,ra,ro) : �б�������ڼ� ron,�б����뼿 ro //ǥ���������ɼ�ed,�ؽ�Ʈ�������ɼ�edtxt,�������ɼ��ڼ�edn
	myGrid.setColTypes  ("ro,ro,ron,ro,ro,ro,ro,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ron,ron,ro,ro,ron,ro,ron,ron,ron");
	//����߰���
	myGrid.attachHeader ("#rspan,#text_filter,#select_filter,#text_filter,#text_filter,#text_filter,#select_filter,#rspan,#rspan,���� �ܰ�������,���� �ܰ�����,�ܰ�����=(A)+(B)-(C)-(D),���� �Һ��� ���ݴ��,���뿩 �ܰ�����(A),�ʰ����� �뿩��(B),ȯ�޴뿩��(C),�Ű�������(D),�縮��/������ �߰���������,�ܰ����� �����ԱⰣ(����),�����ԱⰣ �ܰ����� ȿ��,�����ԱⰣ �ܰ����� ȿ�� �ݾ�(���� �Һ��ڰ��ݴ��),#rspan,#rspan,�뿩������,�뿩������,���� �뿩�Ⱓ,���� �뿩�Ⱓ,�����ܰ� ����DATA,�����ܰ�,��������� �������� �߰�����,�����������,�뿩������,�뿩������,���� �뿩�Ⱓ,���� �뿩�Ⱓ,�����ܰ� ����DATA,�����ܰ�,�縮�� ������ �������� �߰�����,�縮��1 ����,�뿩������,�뿩������,���� �뿩�Ⱓ,���� �뿩�Ⱓ,�����ܰ� ����DATA,�����ܰ�,�縮��1���� ������ �������� �߰�����,�縮��1 �������,�뿩������,�뿩������,���� �뿩�Ⱓ,���� �뿩�Ⱓ,�����ܰ� ����DATA,�����ܰ�,�縮��2~5 ������ �������� �߰�����,�縮��2~5 ����,�뿩������,�뿩������,���� �뿩�Ⱓ,���� �뿩�Ⱓ,�����ܰ� ����DATA,�����ܰ�,�縮��2~5 ��������� �������� �߰�����,�縮��2~5 �������,�뿩������,�뿩������,���� �뿩�Ⱓ,���� �뿩�Ⱓ,�����ܰ� ����DATA,�����ܰ�,#select_filter,#select_filter,��������� �����ܰ�,�ŵ���,���� �Һ��ڰ� ���,�Ű����� (������� �����ܰ� ����),����,����Ÿ�,����� ����,�������� ����,��������,#text_filter,#rspan,#rspan,#select_filter");
	//���ǰ� ����(right,left,center,justify)
	myGrid.setColAlign  ("center,center,center,center,center,center,center,right,right,right,right,right,right,right,right,right,right,right,right,right,right,center,center,center,center,center,center,center,right,right,right,center,center,center,center,center,right,right,right,center,center,center,center,center,right,right,right,center,center,center,center,center,right,right,right,center,center,center,center,center,right,right,right,center,center,center,center,center,right,center,center,right,right,right,right,right,right,center,center,right,center,center,center,center");
	//�������� �������� Ȱ��ȭ/��Ȱ��ȭ
	myGrid.enableTooltips("false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,false");

	//��������
	myGrid.setColumnColor(",,,,,,,,,#ffeb46,#ffeb46,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
	
	myGrid.setNumberFormat("0,000",7);
	myGrid.setNumberFormat("0,000.00",8);
	myGrid.setNumberFormat("0,000.00%",9);
	myGrid.setNumberFormat("0,000",10);
	myGrid.setNumberFormat("0,000",11);
	myGrid.setNumberFormat("0,000.00%",12);
	myGrid.setNumberFormat("0,000",13);
	myGrid.setNumberFormat("0,000",14);
	myGrid.setNumberFormat("0,000",15);
	myGrid.setNumberFormat("0,000",16);
	myGrid.setNumberFormat("0,000",17);
	myGrid.setNumberFormat("0,000.00",18);
	myGrid.setNumberFormat("0,000.00%",19);
	myGrid.setNumberFormat("0,000",20);
	myGrid.setNumberFormat("0,000.00",21);
	myGrid.setNumberFormat("0,000.00",22); 
	myGrid.setNumberFormat("0,000.00",25);
	myGrid.setNumberFormat("0,000.00",26);
	myGrid.setNumberFormat("0,000",28);
	myGrid.setNumberFormat("0,000",29);
	myGrid.setNumberFormat("0,000",30);
	myGrid.setNumberFormat("0,000.00",33);
	myGrid.setNumberFormat("0,000.00",34);
	myGrid.setNumberFormat("0,000",36);
	myGrid.setNumberFormat("0,000",37);
	myGrid.setNumberFormat("0,000",38);
	myGrid.setNumberFormat("0,000.00",41);
	myGrid.setNumberFormat("0,000.00",42);
	myGrid.setNumberFormat("0,000",44);
	myGrid.setNumberFormat("0,000",45);
	myGrid.setNumberFormat("0,000",46);
	myGrid.setNumberFormat("0,000.00",49);
	myGrid.setNumberFormat("0,000.00",50);
	myGrid.setNumberFormat("0,000",52);
	myGrid.setNumberFormat("0,000",53);
	myGrid.setNumberFormat("0,000",54);
	myGrid.setNumberFormat("0,000.00",57);
	myGrid.setNumberFormat("0,000.00",58);
	myGrid.setNumberFormat("0,000",60);
	myGrid.setNumberFormat("0,000",61);
	myGrid.setNumberFormat("0,000",62);
	myGrid.setNumberFormat("0,000.00",65);
	myGrid.setNumberFormat("0,000.00",66);
	myGrid.setNumberFormat("0,000",68);
	myGrid.setNumberFormat("0,000",71);
	myGrid.setNumberFormat("0,000",72);
	myGrid.setNumberFormat("0,000.00",73);
	myGrid.setNumberFormat("0,000",74);
	myGrid.setNumberFormat("0,000.00",75);
	myGrid.setNumberFormat("0,000",76);
	myGrid.setNumberFormat("0,000",79);
	
	myGrid.attachEvent("onXLS",function(){ document.getElementById("a_1").style.display="block"; });
	myGrid.attachEvent("onXLE",function(){  
		if (!myGrid.getRowsNum())	{
			document.getElementById("a_1").style.display="none"; 
			alert('�ش� ������ �����ϴ�');
		} else {
			document.getElementById("a_1").style.display="none"; 
		}
	});	
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;
	
	//�ٴڱۿ� �߰��� �߰�
	myGrid.attachFooter("���� ��ȣ �ݿ�,#cspan,�հ�,#cspan,#cspan,#cspan,#cspan,#stat_total,,,#stat_total,#stat_total,,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,#stat_total,,,,,,,,#stat_total,,,,,,,,#stat_total,#stat_total,#stat_total,,,,,,#stat_total,#stat_total,#stat_total,,,,,,#stat_total,#stat_total,#stat_total,,,,,,#stat_total,#stat_total,#stat_total,,,,,,#stat_total,,,#stat_total,#stat_total,,#stat_total,,,,,#stat_total,,,,,",["text-align:center;",,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ��ȣ �ݿ�,#cspan,���(��ձݾ� �� ��ձݾ����� ���),#cspan,#cspan,#cspan,#cspan,#stat_average,#stat_average,{#stat_multi_total_avg}7:10,#stat_average,#stat_average,{#stat_multi_total_avg}7:11,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,,{#stat_multi_total_avg}7:20,#stat_average,#stat_average,#stat_average,,,#stat_average,#stat_average,,#stat_average,#stat_average,#stat_average,,,#stat_average,#stat_average,,#stat_average,#stat_average,#stat_average,,,#stat_average,#stat_average,,#stat_average,#stat_average,#stat_average,,,#stat_average,#stat_average,,#stat_average,#stat_average,#stat_average,,,#stat_average,#stat_average,,#stat_average,#stat_average,#stat_average,,,#stat_average,#stat_average,,#stat_average,,,#stat_average,#stat_average,{#stat_multi_total_avg}7:71,#stat_average,#stat_average,#stat_average,,,#stat_average,,,,",["text-align:center;",,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);  
	myGrid.attachFooter("���� ��ȣ �ݿ�,#cspan,���(������� ���),#cspan,#cspan,#cspan,#cspan,,,#stat_average,,,#stat_average,,,,,,,#stat_average,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#stat_average,,,,,,,,,,",["text-align:center;",,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	//�׸��� ����
	myGrid.splitAt(7);
		
    myGrid.enableMathEditing(true);
    myGrid.enableColumnMove(true);      
    myGrid.enableSmartRendering(true);
    myGrid.enableBlockSelection();
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
    myGrid.parse(data,"json");	   


function onKeyPressed(code,ctrl,shift){
	if(code==67&&ctrl){
		if (!myGrid._selectionArea) return alert("You need to select a block area in grid first");
			myGrid.setCSVDelimiter("\t");
			
			myGrid.copyBlockToClipboard()
		}
		if(code==86&&ctrl){
			myGrid.setCSVDelimiter("\t");
			myGrid.pasteBlockFromClipboard()
		}
	return true;
}

</script>
</html>
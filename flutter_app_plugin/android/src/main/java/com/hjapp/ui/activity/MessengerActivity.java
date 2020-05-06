package com.hjapp.ui.activity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.hjapp.flutter_app_plugin.FlutterAppPlugin;

import io.flutter.plugin.common.MethodChannel;

public class MessengerActivity extends AppCompatActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView textView = new TextView(this);
        textView.setText("This is Natvie Page");
        LinearLayout linearLayout = new LinearLayout(this);
        linearLayout.setOrientation(LinearLayout.VERTICAL);
        linearLayout.addView(textView);

        Button button1 = new Button(this);
        button1.setText("getDartMessage");
        button1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FlutterAppPlugin.invokeMethod(new MethodChannel.Result() {
                    @Override
                    public void success(Object o) {
                        if (o != null) {
                            Toast.makeText(MessengerActivity.this, (String) o.toString(), Toast.LENGTH_SHORT).show();
                        }
                    }

                    @Override
                    public void error(String s, String s1, Object o) {

                    }

                    @Override
                    public void notImplemented() {

                    }
                });
            }
        });
        linearLayout.addView(button1);


        Button button = new Button(this);
        button.setText("finish");
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        linearLayout.addView(button);
        setContentView(linearLayout);
    }

    @Override
    protected void onStop() {
        super.onStop();
        FlutterAppPlugin.invokeMethod(null);
    }

}
